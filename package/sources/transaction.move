module airsafe::transaction {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    use airsafe::safe::{Self, Safe};
    use airsafe::ownership;

    struct Transaction has key {
        id: UID,
        /// Index of the transaction in the safe
        index: u64,
        /// ID of the safe that the transaction belongs to
        safe_id: ID,
        /// Address of the transaction creator
        creator: address,
        /// BCS encoded data that represent the transaction instruction
        data: vector<u8>,
        /// Status of the tranaction
        status: u8,
        /// Type of the tranaction
        type: u8,
        /// Owners that have approve the transaction
        approved: vector<address>,
        /// Owners that have rejected the transaction
        rejected: vector<address>,
    }

    const ACTIVE_STATUS: u8 = 0;
    const APPROVED_STATUS: u8 = 1;
    const REJECTED_STATUS: u8 = 2;
    const EXECUTED_STATUS: u8 = 3;

    public fun create(safe: &mut Safe, data: vector<u8>, type: u8, ctx: &mut TxContext) {
        let transaction = create_(safe, data, type, ctx);
        transfer::share_object(transaction);
    }

    public fun create_(safe: &mut Safe, data: vector<u8>, type: u8, ctx: &mut TxContext): Transaction {
        // Assert that the transaction sender is an owner
        ownership::assert_ownership(safe::uid(safe), ctx);

        let id = object::new(ctx);
        let safe_id =  object::id(safe);
        let creator = tx_context::sender(ctx);

        safe::increment_transaction_index(safe);
        let index = safe::transaction_index(safe);

        Transaction {
            id,
            data,
            type,
            index,
            creator,
            safe_id,
            status: ACTIVE_STATUS,
            approved: vector::empty(),
            rejected: vector::empty()
        }
    }
}
