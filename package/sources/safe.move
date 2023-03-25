module airsafe::safe {
    use std::vector;

    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::typed_id;
    use sui::transfer;

    use airsafe::errors;
    use airsafe::ownership;

    struct Safe has key {
        id: UID,
        /// Minumum number of owners required to approve any transaction
        threshold: u64
    }

    public fun create(owners: vector<address>, threshold: u64, ctx: &mut TxContext) {
       let safe = create_(owners, threshold, ctx);
       transfer::share_object(safe);
    }

    public fun create_(owners: vector<address>, threshold: u64, ctx: &mut TxContext): Safe {
        assert!(threshold <= vector::length(&owners), errors::invalid_threshold());

        let safe = Safe { 
            id: object::new(ctx), 
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

    public fun extend(self: &mut Safe): &mut UID {
        &mut self.id
    }
}