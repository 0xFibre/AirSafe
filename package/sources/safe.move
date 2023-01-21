// The safe module. This module defines the safe structure and functions
module airsafe::safe {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};

    use airsafe::error;

    friend airsafe::main;
    friend airsafe::coin;
    friend airsafe::asset;
    friend airsafe::owner;
    friend airsafe::transaction;

    struct Safe has key, store {
        id: UID,
        threshold: u64, // minimum number of owners required to approve any transaction
        creator: address, // address of the safe creator
        owners: VecSet<address>, // cointains the addresses of the safe owners
        transactions_count: u64, // total number of transactions in the safe
        stale_transaction_index: u64, // the index which any transaction before it will be regarded as stale
        transactions: vector<ID> // a vector to hold the transaction IDs of the safe
    }

    /// Creates and returns a new safe instance.
    public(friend) fun new(threshold: u64, owners: vector<address>, ctx: &mut TxContext): Safe {
        let owners_count = vector::length(&owners);

        // ensure that the threshold is more than zero
        assert!(threshold > 0, error::invalid_threshold());

        // ensure that the threshold is less than or equal to the number of owners of the safe
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

    /// Borrows the owners of a safe
    public(friend) fun borrow_owners(self: &Safe): &VecSet<address> {
        &self.owners
    }

    /// Borrows the mutable owners of a safe
    public(friend) fun borrow_owners_mut(self: &mut Safe): &mut VecSet<address> {
        &mut self.owners
    }

    /// Borrows the transactions of a safe
    public(friend) fun borrow_transactions(self: &Safe): &vector<ID> {
        &self.transactions
    }

    /// Borrows the mutable transactions of a safe
    public(friend) fun borrow_transactions_mut(self: &mut Safe): &mut vector<ID> {
        &mut self.transactions
    }

    /// get the transactions count of a safe
    public(friend) fun transactions_count(self: &Safe): u64 {
        self.transactions_count
    }

    /// Increments the transactions count of a safe
    public(friend) fun increment_transactions_count(self: &mut Safe) {
        self.transactions_count = self.transactions_count + 1
    }

    /// Get the number of owners of a safe
    public(friend) fun owners_count(self: &Safe): u64 {
        vec_set::size(&self.owners)
    }

    /// Get the threshold of a safe
    public(friend) fun threshold(self: &Safe): u64 {
        self.threshold
    }

    /// Set the threshold of a safe
    public(friend) fun set_threshold(self: &mut Safe, threshold: u64) {
        assert!(threshold > 0, error::invalid_threshold());
        assert!(threshold <= vec_set::size(&self.owners), error::invalid_threshold());

        self.threshold = threshold
    }

    /// Get the stale transaction index of a safe
    public(friend) fun stale_transaction_index(self: &Safe): u64 {
        self.stale_transaction_index
    }

    /// Set the stale transaction index of a safe
    public(friend) fun set_stale_transaction_index(self: &mut Safe, stale_transaction_index: u64) {
        self.stale_transaction_index = stale_transaction_index
    }

    /// Borrows the mutable UID of a safe
    public(friend) fun borrow_uid_mut(self: &mut Safe): &mut UID {
        &mut self.id
    }
}