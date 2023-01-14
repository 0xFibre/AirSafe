module vallet::owner {
    use std::vector;

    use sui::vec_set;

    use vallet::vallet::{Self, Vallet};
    use vallet::error;
    
    friend vallet::main;
    friend vallet::transaction;

    public(friend) fun add(vallet: &mut Vallet, owner: address) {
        assert!(!is_owner(vallet, owner), error::owner_already_exists());

        vec_set::insert(vallet::borrow_owners_mut(vallet), owner);
    }

    public(friend) fun add_owners(vallet: &mut Vallet, owners: vector<address>) {
        let (i, len) = (0, vector::length(&owners));

        vector::reverse(&mut owners);

        while (i < len) {
            add(vallet, vector::pop_back(&mut owners));
        };

        vector::destroy_empty(owners)
    }

    public(friend) fun remove(vallet: &mut Vallet, owner: address) {
        assert!(is_owner(vallet, owner), error::owner_not_exists());

        vec_set::remove(vallet::borrow_owners_mut(vallet), &owner);
    }

    public(friend) fun remove_owners(vallet: &mut Vallet, owners: vector<address>) {
        let (i, len) = (0, vector::length(&owners));

        while (i < len) {
            remove(vallet, vector::pop_back(&mut owners));
        };

        vector::destroy_empty(owners)
    }

    public(friend) fun is_owner(vallet: &Vallet, owner: address): bool {
        vec_set::contains(vallet::borrow_owners(vallet), &owner)
    }
}