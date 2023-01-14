module vallet::registry {
    use sui::object::{Self, UID, ID};
    use sui::table::{Self, Table};
    use sui::tx_context::{TxContext};
    use sui::vec_set::{Self, VecSet};
    use sui::transfer;

    struct Registry has key {
        id: UID,
        vallets: Table<address, VecSet<ID>>
    }

    friend vallet::owner;

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            vallets: table::new(ctx)
        };

        transfer::share_object(registry);
    }

    public(friend) fun borrow_vallets(self: &Registry): &Table<address, VecSet<ID>> {
        &self.vallets
    }

    public(friend) fun borrow_vallets_mut(self: &mut Registry): &mut Table<address, VecSet<ID>> {
        &mut self.vallets
    }

    public(friend) fun register_vallet(self: &mut Registry, vallet_id: ID, owner: address) {
        if(table::contains(&self.vallets, owner)) {
            let vallets = table::borrow_mut(&mut self.vallets, owner);
            if(!vec_set::contains(vallets, &vallet_id)) {
                vec_set::insert(vallets, vallet_id);
            }
        } else {
            let vallets = vec_set::empty<ID>();
            vec_set::insert(&mut vallets, vallet_id);

            table::add(&mut self.vallets, owner, vallets);
        }
    }
}