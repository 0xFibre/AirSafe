module vallet::main {
    use std::vector;

    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Coin};
    use sui::transfer;
    
    use vallet::safe::{Self, Safe};
    use vallet::transaction::{Self, Transaction};
    use vallet::registry::{Registry};
    use vallet::owner;
    use vallet::error;
    use vallet::coin;

    public entry fun create_safe(registry: &mut Registry, threshold: u64, owners: vector<address>, ctx: &mut TxContext) {
        let safe = safe::new(threshold, owners, ctx);

        assert!(vector::borrow(&owners, 0) == &tx_context::sender(ctx), error::invalid_members());
        owner::add_owners(registry, &mut safe, owners);

        transfer::share_object(safe);
    }

    public entry fun deposit_coin<T>(safe: &mut Safe, coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        coin::deposit<T>(safe, coins, amount, ctx);
    }

    public entry fun create_transaction(safe: &mut Safe, type: u8, data: vector<u8>, ctx: &mut TxContext) {
        let transaction = transaction::create_transaction(safe, type, data, ctx);
        transfer::share_object(transaction);
    }

    public entry fun approve_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::approve_transaction(safe, transaction, ctx);
    }

    public entry fun reject_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::reject_transaction(safe, transaction, ctx);
    }

    public entry fun execute_transfer_transaction<T>(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::execute_transfer_transaction<T>(safe, transaction, ctx);
    }
}