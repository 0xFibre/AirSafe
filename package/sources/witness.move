module airsafe::witness {
    struct Witness has drop { }
    
    friend airsafe::ownership;

    public(friend) fun new_witness(): Witness {
        Witness { }
    }
}