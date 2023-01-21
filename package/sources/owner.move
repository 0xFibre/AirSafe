/// The owner module. This module defines functions for managing owners of safes
module airsafe::owner {
    use std::vector;

    use sui::vec_set;
    use sui::object;

    use airsafe::safe::{Self, Safe};
    use airsafe::registry::{Self, Registry};
    use airsafe::error;
    
    friend airsafe::main;
    friend airsafe::transaction;

    /// Adds owner to safe
    public(friend) fun add(registry: &mut Registry, safe: &mut Safe, owner: address) {
        // ensure that the new owner is not an owner already
        assert!(!is_owner(safe, owner), error::owner_already_exists());

        vec_set::insert(safe::borrow_owners_mut(safe), owner);

        // register the safe, making it part of the new owner safes in the registry
        registry::register_safe(registry, object::id(safe), owner);
    }

    /// Adds multiple owners to a safe 
    public(friend) fun add_owners(registry: &mut Registry, safe: &mut Safe, owners: vector<address>) {
        let (i, len) = (0, vector::length(&owners));

        vector::reverse(&mut owners);

        while (i < len) {
            add(registry, safe, vector::pop_back(&mut owners));
            i = i + 1;
        };

        vector::destroy_empty(owners)
    }

    /// Remove owner from a safe
    public(friend) fun remove(registry: &mut Registry, safe: &mut Safe, owner: address) {
        assert!(is_owner(safe, owner), error::owner_not_exists());

        vec_set::remove(safe::borrow_owners_mut(safe), &owner);

        // ensures that the number of the remaining safe owners is greater than zero; simply not less than one owner
        assert!(vec_set::size(safe::borrow_owners(safe)) > 0, error::owners_empty());

        // unregister the safe, removing it from part of the new safes in the registry
        registry::unregister_safe(registry, object::id(safe), owner);
    }

    /// Removes multiple owners to a safe 
    public(friend) fun remove_owners(registry: &mut Registry, safe: &mut Safe, owners: vector<address>) {
        let (i, len) = (0, vector::length(&owners));

        while (i < len) {
            remove(registry, safe, vector::pop_back(&mut owners));
            i = i + 1;
        };

        vector::destroy_empty(owners)
    }

    /// Returns boolean, depending on whether the address passed is an owner of the safe
    public(friend) fun is_owner(safe: &Safe, owner: address): bool {
        vec_set::contains(safe::borrow_owners(safe), &owner)
    }
}