module airsafe::errors {
    const PREFIX: u64 = 2002;

    public fun invalid_threshold(): u64 {
        PREFIX + 3
    }

    public fun already_owner(): u64 {
        PREFIX + 4
    }

    public fun not_owner(): u64 {
        PREFIX + 5
    }
}