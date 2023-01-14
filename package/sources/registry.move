module vallet::registry {
    use sui::object::{Self, UID, ID};
    use sui::table::{Self, Table};
    use sui::tx_context::{TxContext};
    use sui::vec_set::{Self, VecSet};
    use sui::transfer;

    struct Registry has key {
        id: UID,
        safes: Table<address, VecSet<ID>>
    }

    friend vallet::owner;

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            safes: table::new(ctx)
        };

        transfer::share_object(registry);
    }

    public(friend) fun borrow_safes(self: &Registry): &Table<address, VecSet<ID>> {
        &self.safes
    }

    public(friend) fun borrow_safes_mut(self: &mut Registry): &mut Table<address, VecSet<ID>> {
        &mut self.safes
    }

    public(friend) fun register_safe(self: &mut Registry, safe_id: ID, owner: address) {
        if(table::contains(&self.safes, owner)) {
            let safes = table::borrow_mut(&mut self.safes, owner);
            if(!vec_set::contains(safes, &safe_id)) {
                vec_set::insert(safes, safe_id);
            }
        } else {
            let safes = vec_set::empty<ID>();
            vec_set::insert(&mut safes, safe_id);

            table::add(&mut self.safes, owner, safes);
        }
    }
}