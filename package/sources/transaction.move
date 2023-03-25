module airsafe::transaction {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    use airsafe::safe::Safe;

    struct Transaction has key {
        id: UID,
        safe_id: ID,
        creator: address,
        data: vector<u8>,
    }

    public fun create(safe: &Safe, data: vector<u8>, ctx: &mut TxContext) {
        let transaction = create_(safe, data, ctx);
        transfer::share_object(transaction);
    }

    public fun create_(safe: &Safe, data: vector<u8>, ctx: &mut TxContext): Transaction {
        Transaction {
            id: object::new(ctx),
            safe_id: object::id(safe),
            creator: tx_context::sender(ctx),
            data
        }
    }
}