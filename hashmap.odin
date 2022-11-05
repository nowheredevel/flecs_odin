package flecs

import "core:c"

HmBucket :: struct
{
    keys: Vec,
    values: Vec,
}

Hashmap :: struct
{
    hash: hash_value_action_t,
    compare: compare_action_t,
    key_size: size_t,
    value_size: size_t,
    hashmap_allocator: ^BlockAllocator,
    impl: Map,
}

HashmapIter :: struct
{
    it: MapIter,
    bucket: ^HmBucket,
    index: c.int32_t,
}

HashmapResult :: struct
{
    key: rawptr,
    value: rawptr,
    hash: c.uint64_t,
}

