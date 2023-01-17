module airsafe::main {
    use std::vector;

    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Coin};
    use sui::object;
    use sui::transfer;
    
    use airsafe::safe::{Self, Safe};
    use airsafe::transaction::{Self, Transaction};
    use airsafe::registry::{Registry};
    use airsafe::owner;
    use airsafe::error;
    use airsafe::coin;

    public entry fun create_safe(registry: &mut Registry, threshold: u64, owners: vector<address>, ctx: &mut TxContext) {
        assert!(vector::borrow(&owners, 0) == &tx_context::sender(ctx), error::invalid_members());

        let safe = safe::new(threshold, owners, ctx);
        owner::add_owners(registry, &mut safe, owners);

        transfer::share_object(safe);
    }

    public entry fun deposit_coin<T>(safe: &mut Safe, payment: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        coin::deposit<T>(safe, payment, amount, ctx);
    }

    public entry fun create_transaction(safe: &mut Safe, type: u8, data: vector<u8>, ctx: &mut TxContext) {
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        let transaction = transaction::create_transaction(safe, type, data, ctx);
        transaction::approve_transaction(safe, &mut transaction, ctx);

        transfer::share_object(transaction);
    }

    public entry fun approve_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        transaction::approve_transaction(safe, transaction, ctx);
    }

    public entry fun reject_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        transaction::reject_transaction(safe, transaction, ctx);
    }

    public entry fun execute_coin_withdrawal<T>(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        transaction::execute_coin_withdrawal<T>(safe, transaction, ctx);
    }

    public entry fun execute_policy_change(registry: &mut Registry, safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        transaction::execute_policy_change(registry, safe, transaction, ctx);
    }
}