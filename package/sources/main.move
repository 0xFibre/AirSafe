module vallet::main {
    use std::vector;

    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Coin};
    use sui::transfer;
    
    use vallet::vallet::{Self, Vallet};
    use vallet::transaction::{Self, Transaction};
    use vallet::registry::{Registry};
    use vallet::owner;
    use vallet::coin;

    public entry fun create_vallet(registry: &mut Registry, name: vector<u8>, threshold: u64, owners: vector<address>, ctx: &mut TxContext) {
        let vallet = vallet::new(name, threshold, owners, ctx);

        vector::push_back(&mut owners, tx_context::sender(ctx));
        owner::add_owners(registry, &mut vallet, owners);

        transfer::share_object(vallet);
    }

    public entry fun deposit_coin<T>(vallet: &mut Vallet, coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        coin::deposit<T>(vallet, coins, amount, ctx);
    }

    public entry fun create_transaction(vallet: &mut Vallet, type: u8, data: vector<u8>, ctx: &mut TxContext) {
        let transaction = transaction::create_transaction(vallet, type, data, ctx);
        transfer::share_object(transaction);
    }

    public entry fun approve_transaction(vallet: &mut Vallet, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::approve_transaction(vallet, transaction, ctx);
    }

    public entry fun reject_transaction(vallet: &mut Vallet, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::reject_transaction(vallet, transaction, ctx);
    }

    public entry fun execute_transfer_transaction<T>(vallet: &mut Vallet, transaction: &mut Transaction, ctx: &mut TxContext) {
        transaction::execute_transfer_transaction<T>(vallet, transaction, ctx);
    }
}