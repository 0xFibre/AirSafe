module vallet::vallet {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::bag::{Self, Bag};
    use sui::tx_context::{TxContext};
    use sui::vec_set::{Self, VecSet};

    use vallet::error;

    friend vallet::main;
    friend vallet::coin;
    friend vallet::owner;
    friend vallet::transaction;

    struct Vallet has key, store {
        id: UID,
        threshold: u64,
        coins: Bag,
        owners: VecSet<address>,
        transactions_count: u64,
        transactions: vector<ID>
    }

    public(friend) fun new(threshold: u64, owners: vector<address>, ctx: &mut TxContext): Vallet {
        let owners_count = vector::length(&owners) + 1;
        assert!(threshold <= owners_count, error::invalid_threshold());

        Vallet {
            id: object::new(ctx),
            threshold,
            coins: bag::new(ctx),
            owners: vec_set::empty(),
            transactions_count: 0,
            transactions: vector::empty()
        }
    }

    public(friend) fun borrow_owners(self: &Vallet): &VecSet<address> {
        &self.owners
    }

    public(friend) fun borrow_owners_mut(self: &mut Vallet): &mut VecSet<address> {
        &mut self.owners
    }

    public(friend) fun borrow_coins(self: &Vallet): &Bag {
        &self.coins
    }

    public(friend) fun borrow_coins_mut(self: &mut Vallet): &mut Bag {
        &mut self.coins
    }

    public(friend) fun borrow_transactions(self: &Vallet): &vector<ID> {
        &self.transactions
    }

    public(friend) fun borrow_transactions_mut(self: &mut Vallet): &mut vector<ID> {
        &mut self.transactions
    }

    public(friend) fun transactions_count(self: &Vallet): u64 {
        self.transactions_count
    }

    public(friend) fun increment_transactions_count(self: &mut Vallet) {
        self.transactions_count = self.transactions_count + 1
    }

    public(friend) fun owners_count(self: &Vallet): u64 {
        vec_set::size(&self.owners)
    }

    public(friend) fun threshold(self: &Vallet): u64 {
        self.threshold
    }
}