module airsafe::safe {
    use std::vector;

    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui_utils::typed_id;
    use sui::transfer;

    use airsafe::ownership;

    struct Safe has key {
        id: UID,
        /// Minumum number of owners required to approve any transaction
        threshold: u64,
        /// Last created transaction index
        transaction_index: u64,
        /// Last stale transaction index, All transaction before this index are considered stale
        stale_transaction_index: u64
    }

    const EInvalidThreshold: u64 = 0;

    public entry fun create(owners: vector<address>, threshold: u64, ctx: &mut TxContext) {
       let safe = create_(owners, threshold, ctx);
       transfer::share_object(safe);
    }

    public fun create_(owners: vector<address>, threshold: u64, ctx: &mut TxContext): Safe {
        assert!(threshold <= vector::length(&owners), EInvalidThreshold);

        let safe = Safe {
            id: object::new(ctx),
            transaction_index: 0,
            stale_transaction_index: 0,
            threshold
        };

        let typed_id = typed_id::new(&safe);
        ownership::initialize(&mut safe.id, owners, typed_id);

        safe
    }

    // ========== Getter functions ==========

    public fun threshold(self: &Safe): u64 {
        self.threshold
    }

    public fun transaction_index(self: &Safe): u64 {
        self.transaction_index
    }

    public fun stale_transaction_index(self: &Safe): u64 {
        self.stale_transaction_index
    }

    public fun extend(self: &mut Safe): &mut UID {
        &mut self.id
    }
    
    public fun uid(self: &Safe): &UID {
        &self.id
    }

    // ========== Setter functions ==========

    public fun increment_transaction_index(self: &mut Safe) {
        self.transaction_index = self.transaction_index + 1
    }

    public fun set_stale_transaction_index(self: &mut Safe, index: u64) {
        self.stale_transaction_index = index
    }
}