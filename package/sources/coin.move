module vallet::coin {
    use std::string::{Self, String};
    use std::type_name;
    use std::vector;

    use sui::pay;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::bag::{Self};
    use sui::tx_context::{TxContext};
    use sui::transfer;

    use vallet::vallet::{Self, Vallet};
    use vallet::error;

    friend vallet::main;
    friend vallet::transaction;

    public(friend) fun deposit<T>(vallet: &mut Vallet, coins: vector<Coin<T>>, amount: u64, ctx: &mut TxContext) {
        let coin = vector::pop_back(&mut coins);
        
        pay::join_vec(&mut coin, coins);

        let split_coin = coin::split(&mut coin, amount, ctx);
        let balance = coin::into_balance(split_coin);

        if(coin::value(&coin) == 0) {
            coin::destroy_zero(coin);
        } else {
            pay::keep(coin, ctx);
        };

        write_deposit(vallet, balance);
    }

    public(friend) fun withdraw<T>(vallet: &mut Vallet, amount: u64, recipient: address, ctx: &mut TxContext) {
        let withdrawal_balance = write_withdrawal<T>(vallet, amount);
        let withdrawal_coin = coin::from_balance(withdrawal_balance, ctx);

        transfer::transfer(withdrawal_coin, recipient);
    }

    fun write_deposit<T>(vallet: &mut Vallet, new_balance: Balance<T>) {
        let coin_type = string::from_ascii(type_name::into_string(type_name::get<T>()));
        let coins = vallet::borrow_coins_mut(vallet);

        if(bag::contains_with_type<String, Balance<T>>(coins, coin_type)) {
            let balance = bag::borrow_mut<String, Balance<T>>(coins, coin_type);
            balance::join(balance, new_balance);
        } else {
            bag::add<String, Balance<T>>(coins, coin_type, new_balance);
        }
    }

    fun write_withdrawal<T>(vallet: &mut Vallet, amount: u64): Balance<T> {
        let coin_type = string::from_ascii(type_name::into_string(type_name::get<T>()));
        let coins = vallet::borrow_coins_mut(vallet);

        assert!(bag::contains_with_type<String, Balance<T>>(coins, coin_type), error::coin_not_found());
 
        let balance = bag::borrow_mut<String, Balance<T>>(coins, coin_type);
        balance::split(balance, amount)
    }
}