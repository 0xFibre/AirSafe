/// The main module. It is only module that contains entry functions and plugs in to other modules
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
    use airsafe::asset;

    /// The entry function to create a safe. 
    /// It creates a safe and set its initial configuration.
    public entry fun create_safe(registry: &mut Registry, threshold: u64, owners: vector<address>, ctx: &mut TxContext) {
        // ensure that the transaction sender address is the first item in the owners vector... 
        assert!(vector::borrow(&owners, 0) == &tx_context::sender(ctx), error::invalid_members());

        let safe = safe::new(threshold, owners, ctx);

        // add the owners to the safe and registry
        owner::add_owners(registry, &mut safe, owners);

        transfer::share_object(safe);
    }

    /// The entry point for depositing coins into a safe.
    /// It allows the deposit of any type of coin into the safe
    public entry fun deposit_coin<T>(safe: &mut Safe, payment: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        coin::deposit<T>(safe, payment, amount, ctx);
    }

    /// The entry point for depositing assets into a safe.
    public entry fun deposit_asset<A: key + store>(safe: &mut Safe, asset: A, _ctx: &mut TxContext) {
        asset::deposit<A>(safe, asset);
    }

    /// The entry point for creating transations in a safe.
    public entry fun create_transaction(safe: &mut Safe, type: u8, data: vector<u8>, ctx: &mut TxContext) {
        // ensure that the transaction sender is an owner of the safe
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        let transaction = transaction::create_transaction(safe, type, data, ctx);
        transaction::approve_transaction(safe, &mut transaction, ctx);

        transfer::share_object(transaction);
    }

    /// The entry point for approving a transation in a safe.
    public entry fun approve_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        // ensure that the transaction belongs to the safe
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        // ensure that the transaction sender is an owner of the safe
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        transaction::approve_transaction(safe, transaction, ctx);
    }

    /// The entry point for rejecting a transation in a safe.
    public entry fun reject_transaction(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        // ensure that the transaction belongs to the safe
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        // ensure that the transaction sender is an owner of the safe
        assert!(owner::is_owner(safe, tx_context::sender(ctx)), error::not_safe_owner());

        transaction::reject_transaction(safe, transaction, ctx);
    }

    /// The entry point for executing coin withdrawal transations in a safe.
    public entry fun execute_coin_withdrawal_transaction<T>(safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        // ensure that the transaction belongs to the safe
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        transaction::execute_coin_withdrawal_transaction<T>(safe, transaction, ctx);
    }

    /// The entry point for executing asset withdrawal transations in a safe.
     public entry fun execute_asset_withdrawal_transaction<A: key + store>(safe: &mut Safe, transaction: &mut Transaction, _ctx: &mut TxContext) {
        // ensure that the transaction belongs to the safe
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        transaction::execute_asset_withdrawal_transaction<A>(safe, transaction);
    }

    /// The entry point for executing policy change transations in a safe.
    /// Policy changes are: addition or removal of owners and changing of threshold.
    public entry fun execute_policy_change_transaction(registry: &mut Registry, safe: &mut Safe, transaction: &mut Transaction, ctx: &mut TxContext) {
        // ensure that the transaction belongs to the safe
        assert!(object::borrow_id(safe) == &transaction::safe_id(transaction), error::safe_transaction_mismatch());

        transaction::execute_policy_change_transaction(registry, safe, transaction, ctx);
    }
}