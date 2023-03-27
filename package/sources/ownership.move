module airsafe::ownership {
    use std::vector;

    use sui::object::UID;
    use sui_utils::typed_id::TypedID;
    use sui::tx_context::TxContext;

    use ownership::ownership;
    use ownership::tx_authority;

    struct Witness has drop { }

    const EAlreadyOwner: u64 = 0;
    const ENotOwner: u64 = 1;

    public fun initialize<T: key>(uid: &mut UID, owners: vector<address>, typed_id: TypedID<T>) {
        let auth = tx_authority::begin_with_type(&Witness { });

        ownership::initialize_with_module_authority(uid, typed_id, &auth);
        ownership::as_shared_object_(uid, owners, owners, &auth);
    }

    public fun add_owner(uid: &mut UID, addr: address, ctx: &mut TxContext) {
        let owners = owners(uid);
        let auth = tx_authority::begin(ctx);

        if(is_owner(uid, addr)) {
            abort EAlreadyOwner
        } else {
            vector::push_back(&mut owners, addr);
            ownership::transfer(uid, owners, &auth);
            ownership::add_transfer_auth(uid, addr, &auth);
        }
    }

    public fun remove_owner(uid: &mut UID, addr: address, ctx: &mut TxContext) {
        let owners = owners(uid);
        let auth = tx_authority::begin(ctx);
        let (is_owner, index) = vector::index_of(&owners, &addr);
        
        if(!is_owner) {
            abort ENotOwner
        } else {
            vector::remove(&mut owners, index);
            ownership::transfer(uid, owners, &auth);
            ownership::remove_transfer_auth(uid, addr, &auth);
        }
    }

    public fun is_owner(uid: &UID, addr: address): bool {
        vector::contains(&owners(uid), &addr)
    }

    public fun owners(uid: &UID): vector<address> {
        let (_, owners, _, _, _) = ownership::get_ownership(uid);
        owners
    }

    // ========== Assertions =========

    public fun assert_ownership(uid: &UID, ctx: &TxContext) {
        let auth = tx_authority::begin(ctx);
        assert!(ownership::is_authorized_by_owner(uid, &auth), ENotOwner)
    }
}