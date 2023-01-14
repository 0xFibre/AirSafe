module vallet::transaction {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};
    use sui::bcs::{Self, BCS};

    use vallet::safe::{Self, Safe};
    use vallet::owner;
    use vallet::coin;
    use vallet::error;

    friend vallet::main;

    struct Transaction has key, store {
        id: UID,
        index: u64,
        safe_id: ID,
        creator: address,
        data: vector<u8>,
        type: u8,
        status: u8,
        approvers: VecSet<address>,
        rejecters: VecSet<address>,
    }

    struct TransferData has drop {
        amount: u64,
        recipient: address,
        coin_type: vector<u8>
    }

    const ACTIVE_TRANSACTION_STATUS: u8 = 1;
    const REJECTED_TRANSACTION_STATUS: u8 = 2;
    const READY_TRANSACTION_STATUS: u8 = 3;
    const EXECUTED_TRANSACTION_STATUS: u8 = 4;

    const TRANSFER_TRANSACTION_TYPE: u8 = 1;

    public(friend) fun create_transaction(safe: &mut Safe, type: u8, data: vector<u8>, ctx: &mut TxContext): Transaction {
       let sender = tx_context::sender(ctx);

        assert!(owner::is_owner(safe, sender), error::not_safe_owner());
        validate_transaction_data(type, data);

        let transaction = Transaction {
            id: object::new(ctx),
            safe_id: object::id(safe),
            status: ACTIVE_TRANSACTION_STATUS,
            index: safe::transactions_count(safe),
            creator: sender,
            approvers: vec_set::empty(),
            rejecters: vec_set::empty(),
            type,
            data,
        };

        let transactions = safe::borrow_transactions_mut(safe);

        vector::push_back(transactions, object::id(&transaction));
        safe::increment_transactions_count(safe);

        transaction
    }

    public(friend) fun approve_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        assert!(object::borrow_id(safe) == &transaction.safe_id, error::safe_transaction_mismatch());
        assert!(owner::is_owner(safe, sender), error::not_safe_owner());
        assert!(!vec_set::contains(&transaction.approvers, &sender), error::already_approved_transaction());
        assert!(!vec_set::contains(&transaction.rejecters, &sender), error::already_rejected_transaction());

        vec_set::insert(&mut transaction.approvers, sender);

        if(vec_set::size(&transaction.approvers) >= safe::threshold(safe)) {
            transaction.status = READY_TRANSACTION_STATUS;
        }
    }

    public(friend) fun reject_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        assert!(object::borrow_id(safe) == &transaction.safe_id, error::safe_transaction_mismatch());
        assert!(owner::is_owner(safe, sender), error::not_safe_owner());
        assert!(!vec_set::contains(&transaction.approvers, &sender), error::already_approved_transaction());
        assert!(!vec_set::contains(&transaction.rejecters, &sender), error::already_rejected_transaction());

        vec_set::insert(&mut transaction.rejecters, sender);

        let limit = safe::owners_count(safe) - safe::threshold(safe);
        if(vec_set::size(&transaction.rejecters) > limit) {
            transaction.status = REJECTED_TRANSACTION_STATUS;
        }
    }

    public(friend) fun execute_transfer_transaction<T>(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(object::borrow_id(safe) == &transaction.safe_id, error::safe_transaction_mismatch());
        assert!(transaction.type == TRANSFER_TRANSACTION_TYPE, error::invalid_transaction_type());
        
        let bcs = bcs::new(transaction.data);
        let data = deserialize_transfer_data(bcs);

        coin::withdraw<T>(safe, data.amount, data.recipient, ctx);
    }

    fun validate_transaction_data(type: u8, data: vector<u8>) {
        let bcs = bcs::new(data);

        if(type == TRANSFER_TRANSACTION_TYPE) {
            deserialize_transfer_data(bcs)
        } else {
            abort error::invalid_transaction_type()
        };
    }

    fun deserialize_transfer_data(bcs: BCS): TransferData {
        let data = TransferData {
            coin_type: bcs::peel_vec_u8(&mut bcs),
            amount: bcs::peel_u64(&mut bcs),
            recipient: bcs::peel_address(&mut bcs),
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }
}