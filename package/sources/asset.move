module airsafe::asset {
    use sui::dynamic_object_field as ofield;
    use sui::transfer;
    use sui::object::{Self, ID};

    use airsafe::safe::{Self, Safe};
    use airsafe::error;

    friend airsafe::main;
    friend airsafe::transaction;

    public(friend) fun deposit<A: key + store>(safe: &mut Safe, asset: A) {
        make_deposit(safe, asset);
    }

    public(friend) fun withdraw<A: key + store>(safe: &mut Safe, asset_id: vector<u8>, recipient: address) {
        let asset = make_withdrawal<A>(safe, object::id_from_bytes(asset_id));
        transfer::transfer(asset, recipient);
    }

    fun make_deposit<A: key + store>(safe: &mut Safe, asset: A) {
       let safe_id = safe::borrow_uid_mut(safe);
       let asset_id = object::id(&asset);

        ofield::add<ID, A>(safe_id, asset_id, asset);
    }

    fun make_withdrawal<A: key + store>(safe: &mut Safe, asset_id: ID): A {
        let safe_id = safe::borrow_uid_mut(safe);

        assert!(ofield::exists_with_type<ID, A>(safe_id, asset_id), error::asset_not_found());

        ofield::remove<ID, A>(safe_id, asset_id)
    }
}