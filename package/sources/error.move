module vallet::error {
    const ERROR_PREFIX: u64 = 2002;

    public fun invalid_threshold(): u64 {
        ERROR_PREFIX + 2
    }

    public fun owner_already_exists(): u64 {
        ERROR_PREFIX + 3
    }

    public fun owner_not_exists(): u64 {
        ERROR_PREFIX + 4
    }

    public fun coin_not_found(): u64 {
        ERROR_PREFIX + 5
    }

    public fun invalid_transaction_data(): u64 {
        ERROR_PREFIX + 6
    }

    public fun invalid_transaction_type(): u64 {
        ERROR_PREFIX + 7
    }

    public fun not_safe_owner(): u64 {
        ERROR_PREFIX + 8
    }

    public fun already_approved_transaction(): u64 {
        ERROR_PREFIX + 9
    }

    public fun already_rejected_transaction(): u64 {
        ERROR_PREFIX + 9
    }

    public fun safe_transaction_mismatch(): u64 {
        ERROR_PREFIX + 9
    }

    public fun invalid_members(): u64 {
        ERROR_PREFIX + 10
    }
}