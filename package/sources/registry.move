module vallet::registry {
    use sui::object::{Self, UID, ID};
    use sui::table::{Self, Table};
    use sui::tx_context::{TxContext};
    use sui::transfer;

    struct Registry has key {
        id: UID,
        vallets: Table<address, vector<ID>>
    }

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            vallets: table::new(ctx)
        };

        transfer::share_object(registry);
    }
}