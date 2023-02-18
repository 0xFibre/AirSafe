/// The Coin module. This module handles the deposit and withdrawal of coins from safes
module airsafe::coin {
    use std::ascii;
    use std::type_name;
    use std::vector;

    use sui::pay;
    use sui::object::{Self, ID};
    use sui::coin::{Self, Coin};
    use sui::dynamic_object_field as ofield;
    use sui::tx_context::{Self, TxContext};
    use sui::event::emit;
    use sui::transfer;

    use airsafe::safe::{Self, Safe};
    use airsafe::error;

    friend airsafe::main;
    friend airsafe::transaction;

    struct CoinDeposited has copy, drop {
        safe_id: ID,
        coin_type: vector<u8>,
        depositor: address,
        amount: u64
    }

    struct CoinWithdrawn has copy, drop {
        safe_id: ID,
        coin_type: vector<u8>,
        recipient: address,
        amount: u64
    }

    /// Deposits an amount of coin into the safe
    public(friend) fun deposit<T>(safe: &mut Safe, coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        let payment = collect_payment(coins, amount, ctx);
        make_deposit(safe, payment, ctx);
    }

    /// Withdraws an amount of coin from the safe
    public(friend) fun withdraw<T>(safe: &mut Safe, amount: u64, recipient: address, ctx: &mut TxContext) {
        let (coin_type, withdrawal) = make_withdrawal<T>(safe, amount, ctx);

        emit(CoinWithdrawn {
            safe_id: object::id(safe),
            coin_type,
            recipient,
            amount: coin::value(&withdrawal),
        });


        transfer::transfer(withdrawal, recipient);
    }

    /// internal function to deposit coin into the safe
    fun make_deposit<T>(safe: &mut Safe, new_coin: Coin<T>, ctx: &TxContext) {
        // extracts the coin type name and convert into string
        let coin_type = ascii::into_bytes(type_name::into_string(type_name::get<T>()));
        let safe_id = safe::borrow_uid_mut(safe);

        emit(CoinDeposited {
            safe_id: object::uid_to_inner(safe_id),
            coin_type,
            depositor: tx_context::sender(ctx),
            amount: coin::value(&new_coin),
        });

        // checks if the coin with the type `T` already exists in safe
        if(ofield::exists_with_type<vector<u8>, Coin<T>>(safe_id, coin_type)) {
            let coin = ofield::borrow_mut<vector<u8>, Coin<T>>(safe_id, coin_type);

            // join the newly deposited coin with the safe existing coin
            coin::join(coin, new_coin);
        } else {
            // adds the new coin to the safe, if there's no coin with type `T`
            ofield::add<vector<u8>, Coin<T>>(safe_id, coin_type, new_coin);
        }
    }

    fun make_withdrawal<T>(safe: &mut Safe, amount: u64, ctx: &mut TxContext): (vector<u8>, Coin<T>) {
        // extracts the coin type name and convert into string
        let coin_type = ascii::into_bytes(type_name::into_string(type_name::get<T>()));
        let safe_id = safe::borrow_uid_mut(safe);

        // ensures that coin with type `T` exists in the safe
        assert!(ofield::exists_with_type<vector<u8>, Coin<T>>(safe_id, coin_type), error::coin_not_found());
 
        let coin = ofield::borrow_mut<vector<u8>, Coin<T>>(safe_id, coin_type);

        // splits the coin with the amount to be withdrawn and returns it
        (coin_type, coin::split(coin, amount, ctx))
    }

    fun collect_payment<T>(coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext): Coin<T> {
        let coin = vector::pop_back(&mut coins);
        pay::join_vec(&mut coin, coins);

        let split_coin = coin::split(&mut coin, amount, ctx);

        if(coin::value(&coin) == 0) {
            coin::destroy_zero(coin);
        } else {
            pay::keep(coin, ctx);
        };

        split_coin
    }
}