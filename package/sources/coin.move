module airsafe::coin {
    use std::ascii;
    use std::vector;
    use std::type_name;

    use sui::object::{UID};
    use sui::coin::{Self, Coin};
    use sui::dynamic_object_field as dof;
    use sui::tx_context::TxContext;
    use sui::pay;

    struct Key has copy, store, drop { 
        value: vector<u8> 
    }

    public fun deposit<T>(uid: &mut UID, amount: u64, coins: vector<Coin<T>>, ctx: &mut TxContext) {
        let key = Key { value: type_to_bytes<T>() };
        let deposit = collect_deposit(amount, coins, ctx);

        if(dof::exists_with_type<Key, Coin<T>>(uid, key)) {
            let coin = dof::borrow_mut(uid, key);
            coin::join(coin, deposit)
        } else {
            dof::add<Key, Coin<T>>(uid, key, deposit)
        };
    }


    // ========== Helper functions =========

    fun type_to_bytes<T>(): vector<u8> {
        let type_string = type_name::into_string(type_name::get<T>());
        ascii::into_bytes(type_string)
    }

    fun merge_coins<T>(coins: vector<Coin<T>>): Coin<T> {
        let coin = vector::pop_back(&mut coins);
        pay::join_vec(&mut coin, coins);

        coin
    }

    fun collect_deposit<T>(amount: u64, coins: vector<Coin<T>>, ctx: &mut TxContext): Coin<T> {
        let coin = merge_coins(coins);
        let deposit = coin::split(&mut coin, amount, ctx);
        pay::keep(coin, ctx);

        deposit
    }
}