
module airsafe::tst {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct TST has drop {}

    fun init(witness: TST, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TST>(witness, 6, b"TST", b"Test Coin", b"", option::none(), ctx);
        transfer::freeze_object(metadata);
        transfer::transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<TST>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<TST>, coin: Coin<TST>) {
        coin::burn(treasury_cap, coin);
    }
}