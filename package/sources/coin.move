module airsafe::coin {
    use std::ascii;
    use std::type_name;
    use std::vector;

    use sui::pay;
    use sui::coin::{Self, Coin};
    use sui::dynamic_object_field as ofield;
    use sui::tx_context::{TxContext};
    use sui::transfer;

    use airsafe::safe::{Self, Safe};
    use airsafe::error;

    friend airsafe::main;
    friend airsafe::transaction;

    public(friend) fun deposit<T>(safe: &mut Safe, coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        let payment = collect_payment(coins, amount, ctx);
        make_deposit(safe, payment);
    }

    public(friend) fun withdraw<T>(safe: &mut Safe, amount: u64, recipient: address, ctx: &mut TxContext) {
        let withdrawal = make_withdrawal<T>(safe, amount, ctx);
        transfer::transfer(withdrawal, recipient);
    }

    fun make_deposit<T>(safe: &mut Safe, new_coin: Coin<T>) {
        let coin_type = ascii::into_bytes(type_name::into_string(type_name::get<T>()));
        let safe_id = safe::borrow_uid_mut(safe);

        if(ofield::exists_with_type<vector<u8>, Coin<T>>(safe_id, coin_type)) {
            let coin = ofield::borrow_mut<vector<u8>, Coin<T>>(safe_id, coin_type);
            coin::join(coin, new_coin);
        } else {
            ofield::add<vector<u8>, Coin<T>>(safe_id, coin_type, new_coin);
        }
    }

    fun make_withdrawal<T>(safe: &mut Safe, amount: u64, ctx: &mut TxContext): Coin<T> {
        let coin_type = ascii::into_bytes(type_name::into_string(type_name::get<T>()));
        let safe_id = safe::borrow_uid_mut(safe);

        assert!(ofield::exists_with_type<vector<u8>, Coin<T>>(safe_id, coin_type), error::coin_not_found());
 
        let coin = ofield::borrow_mut<vector<u8>, Coin<T>>(safe_id, coin_type);
        coin::split(coin, amount, ctx)
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