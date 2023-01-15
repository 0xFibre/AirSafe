module vallet::safe {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};

    use vallet::error;

    friend vallet::main;
    friend vallet::coin;
    friend vallet::owner;
    friend vallet::transaction;

    struct Safe has key, store {
        id: UID,
        threshold: u64,
        creator: address,
        owners: VecSet<address>,
        transactions_count: u64,
        transactions: vector<ID>
    }

    public(friend) fun new(threshold: u64, owners: vector<address>, ctx: &mut TxContext): Safe {
        let owners_count = vector::length(&owners) + 1;

        assert!(threshold > 0, error::invalid_threshold());
        assert!(threshold <= owners_count, error::invalid_threshold());

        Safe {
            id: object::new(ctx),
            threshold,
            creator: tx_context::sender(ctx),
            owners: vec_set::empty(),
            transactions_count: 0,
            transactions: vector::empty()
        }
    }

    public(friend) fun borrow_owners(self: &Safe): &VecSet<address> {
        &self.owners
    }

    public(friend) fun borrow_owners_mut(self: &mut Safe): &mut VecSet<address> {
        &mut self.owners
    }

    public(friend) fun borrow_transactions(self: &Safe): &vector<ID> {
        &self.transactions
    }

    public(friend) fun borrow_transactions_mut(self: &mut Safe): &mut vector<ID> {
        &mut self.transactions
    }

    public(friend) fun transactions_count(self: &Safe): u64 {
        self.transactions_count
    }

    public(friend) fun increment_transactions_count(self: &mut Safe) {
        self.transactions_count = self.transactions_count + 1
    }

    public(friend) fun owners_count(self: &Safe): u64 {
        vec_set::size(&self.owners)
    }

    public(friend) fun threshold(self: &Safe): u64 {
        self.threshold
    }

    public(friend) fun borrow_uid_mut(self: &mut Safe): &mut UID {
        &mut self.id
    }
}