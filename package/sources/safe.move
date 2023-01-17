module airsafe::safe {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};

    use airsafe::error;

    friend airsafe::main;
    friend airsafe::coin;
    friend airsafe::owner;
    friend airsafe::transaction;

    struct Safe has key, store {
        id: UID,
        threshold: u64,
        creator: address,
        owners: VecSet<address>,
        transactions_count: u64,
        stale_transaction_index: u64,
        transactions: vector<ID>
    }

    public(friend) fun new(threshold: u64, owners: vector<address>, ctx: &mut TxContext): Safe {
        let owners_count = vector::length(&owners);

        assert!(threshold > 0, error::invalid_threshold());
        assert!(threshold <= owners_count, error::invalid_threshold());

        Safe {
            id: object::new(ctx),
            threshold,
            creator: tx_context::sender(ctx),
            owners: vec_set::empty(),
            transactions_count: 0,
            stale_transaction_index: 0,
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

    public(friend) fun set_threshold(self: &mut Safe, threshold: u64) {
        assert!(threshold > 0, error::invalid_threshold());
        assert!(threshold <= vec_set::size(&self.owners), error::invalid_threshold());

        self.threshold = threshold
    }

    public(friend) fun stale_transaction_index(self: &Safe): u64 {
        self.stale_transaction_index
    }

    public(friend) fun set_stale_transaction_index(self: &mut Safe, stale_transaction_index: u64) {
        self.stale_transaction_index = stale_transaction_index
    }

    public(friend) fun borrow_uid_mut(self: &mut Safe): &mut UID {
        &mut self.id
    }
}