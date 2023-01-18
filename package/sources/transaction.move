module airsafe::transaction {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};
    use sui::bcs::{Self, BCS};

    use airsafe::safe::{Self, Safe};
    use airsafe::registry::{Registry};
    use airsafe::owner;
    use airsafe::coin;
    use airsafe::asset;
    use airsafe::error;

    friend airsafe::main;

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

    struct CoinWithdrawalData has drop {
        coin_type: vector<u8>,
        amount: u64,
        recipient: address,
    }

    struct AssetWithdrawalData has drop {
        asset_id: address,
        asset_type: vector<u8>,
        recipient: address,
    }

    struct AddOwnerData has drop {
        owner: address,
        threshold: u64
    }

    struct RemoveOwnerData has drop {
        owner: address,
        threshold: u64
    }

    struct ChangeThresholdData has drop {
        threshold: u64,
    }

    const ACTIVE_TRANSACTION_STATUS: u8 = 0;
    const APPROVED_TRANSACTION_STATUS: u8 = 1;
    const REJECTED_TRANSACTION_STATUS: u8 = 2;
    const EXECUTED_TRANSACTION_STATUS: u8 = 3;

    const COIN_WITHDRAWAL_TRANSACTION_TYPE: u8 = 0;
    const ASSET_WITHDRAWAL_TRANSACTION_TYPE: u8 = 1;
    const ADD_OWNER_TRANSACTION_TYPE: u8 = 2;
    const REMOVE_OWNER_TRANSACTION_TYPE: u8 = 3;
    const CHANGE_THRESHOLD_TRANSACTION_TYPE: u8 = 4;

    public(friend) fun create_transaction(safe: &mut Safe, type: u8, data: vector<u8>, ctx: &mut TxContext): Transaction {

        validate_transaction_data(type, data);
        safe::increment_transactions_count(safe);

        let transaction = Transaction {
            id: object::new(ctx),
            safe_id: object::id(safe),
            status: ACTIVE_TRANSACTION_STATUS,
            index: safe::transactions_count(safe),
            creator: tx_context::sender(ctx),
            approvers: vec_set::empty(),
            rejecters: vec_set::empty(),
            type,
            data,
        };

        let transactions = safe::borrow_transactions_mut(safe);
        vector::push_back(transactions, object::id(&transaction));
        
        transaction
    }

    public(friend) fun approve_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(transaction.index > safe::stale_transaction_index(safe), error::transaction_is_stale());
        assert!(transaction.status == ACTIVE_TRANSACTION_STATUS, error::invalid_transaction_status());

        let sender = tx_context::sender(ctx);

        if(vec_set::contains(&transaction.rejecters, &sender)) {
            vec_set::remove(&mut transaction.rejecters, &sender);
        };

        if(!vec_set::contains(&transaction.approvers, &sender)) {
            vec_set::insert(&mut transaction.approvers, sender);
        };

        if(vec_set::size(&transaction.approvers) >= safe::threshold(safe)) {
            transaction.status = APPROVED_TRANSACTION_STATUS;
        }
    }

    public(friend) fun reject_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(transaction.index > safe::stale_transaction_index(safe), error::transaction_is_stale());
        assert!(transaction.status == ACTIVE_TRANSACTION_STATUS, error::invalid_transaction_status());
        
        let sender = tx_context::sender(ctx);
        
        if(vec_set::contains(&transaction.approvers, &sender)) {
            vec_set::remove(&mut transaction.approvers, &sender);
        };

        if(!vec_set::contains(&transaction.rejecters, &sender)) {
            vec_set::insert(&mut transaction.rejecters, sender);
        };

        let rejections_limit = safe::owners_count(safe) - safe::threshold(safe);
        if(vec_set::size(&transaction.rejecters) > rejections_limit) {
            transaction.status = REJECTED_TRANSACTION_STATUS;
        }
    }

    public(friend) fun execute_coin_withdrawal_transaction<T>(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(transaction.status == APPROVED_TRANSACTION_STATUS, error::invalid_transaction_status());
        
        let bcs = bcs::new(transaction.data);
        let data = deserialize_coin_withdrawal_data(bcs);

        coin::withdraw<T>(safe, data.amount, data.recipient, ctx);

        transaction.status = EXECUTED_TRANSACTION_STATUS;
    }

    public(friend) fun execute_asset_withdrawal_transaction<A: key + store>(safe: &mut Safe, transaction: &mut Transaction) {
        assert!(transaction.status == APPROVED_TRANSACTION_STATUS, error::invalid_transaction_status());
        
        let bcs = bcs::new(transaction.data);
        let data = deserialize_asset_withdrawal_data(bcs);

        asset::withdraw<A>(safe, data.asset_id, data.recipient);

        transaction.status = EXECUTED_TRANSACTION_STATUS;
    }

    public(friend) fun execute_policy_change_transaction(registry: &mut Registry, safe: &mut Safe, transaction: &mut Transaction, _ctx: &mut TxContext) {
        assert!(transaction.status == APPROVED_TRANSACTION_STATUS, error::invalid_transaction_status());
        
        let bcs = bcs::new(transaction.data);
        
        if(transaction.type == ADD_OWNER_TRANSACTION_TYPE) {
            let data = deserialize_add_owner_data(bcs);
            owner::add(registry, safe, data.owner);
            safe::set_threshold(safe, data.threshold);
        } else if(transaction.type == REMOVE_OWNER_TRANSACTION_TYPE) {
            let data = deserialize_remove_owner_data(bcs);
            owner::remove(registry, safe, data.owner);
            safe::set_threshold(safe, data.threshold);
        } else if(transaction.type == CHANGE_THRESHOLD_TRANSACTION_TYPE) {
            let data = deserialize_set_threshold_data(bcs);
            safe::set_threshold(safe, data.threshold);
        } else {
            abort error::invalid_transaction_type()
        };

        let index = safe::transactions_count(safe);
        safe::set_stale_transaction_index(safe, index);
        
        transaction.status = EXECUTED_TRANSACTION_STATUS;
    }

    fun validate_transaction_data(type: u8, data: vector<u8>) {
        let bcs = bcs::new(data);

        if(type == COIN_WITHDRAWAL_TRANSACTION_TYPE) {
            deserialize_coin_withdrawal_data(bcs);
        } else if(type == ASSET_WITHDRAWAL_TRANSACTION_TYPE) {
            deserialize_asset_withdrawal_data(bcs);
        } else if(type == ADD_OWNER_TRANSACTION_TYPE) {
            deserialize_add_owner_data(bcs);
        } else if(type == REMOVE_OWNER_TRANSACTION_TYPE) {
            deserialize_remove_owner_data(bcs);
        } else if(type == CHANGE_THRESHOLD_TRANSACTION_TYPE) {
            deserialize_set_threshold_data(bcs);
        } else {
            abort error::invalid_transaction_type()
        };
    }

    fun deserialize_coin_withdrawal_data(bcs: BCS): CoinWithdrawalData {
        let data = CoinWithdrawalData {
            coin_type: bcs::peel_vec_u8(&mut bcs),
            amount: bcs::peel_u64(&mut bcs),
            recipient: bcs::peel_address(&mut bcs),
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }

    fun deserialize_asset_withdrawal_data(bcs: BCS): AssetWithdrawalData {
        let data = AssetWithdrawalData {
            asset_id: bcs::peel_address(&mut bcs),
            asset_type: bcs::peel_vec_u8(&mut bcs),
            recipient: bcs::peel_address(&mut bcs),
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }

    fun deserialize_add_owner_data(bcs: BCS): AddOwnerData {
        let data = AddOwnerData {
            owner: bcs::peel_address(&mut bcs),
            threshold: bcs::peel_u64(&mut bcs)
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }

    fun deserialize_remove_owner_data(bcs: BCS): RemoveOwnerData {
        let data = RemoveOwnerData {
            owner: bcs::peel_address(&mut bcs),
            threshold: bcs::peel_u64(&mut bcs)
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }

    fun deserialize_set_threshold_data(bcs: BCS): ChangeThresholdData {
        let data = ChangeThresholdData {
            threshold: bcs::peel_u64(&mut bcs),
        };

        assert!(vector::is_empty(&bcs::into_remainder_bytes(bcs)), error::invalid_transaction_data());

        data
    }

    public(friend) fun safe_id(self: &Transaction): ID {
        self.safe_id
    }
}