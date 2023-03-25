module airsafe::transaction {
    use sui::object::{ID};

    struct Transaction {
        safe_id: ID,
        creator: address,
        data: vector<u8>,
    }
}