package flecs

import "core:c"

HM_Bucket :: struct
{
    keys: Vec,
    values: Vec,
}

HashMap :: struct
{
    hash: Hash_Value_Action,
    compare: Compare_Action,
    key_size: Size,
    value_size: Size,
    hashmap_allocator: ^Block_Allocator,
    bucket_allocator: Block_Allocator,
    impl: Map,
}

HashMap_Iter :: struct
{
    it: Map_Iter,
    bucket: ^HM_Bucket,
    index: i32,
}

HashMap_Result :: struct
{
    key: rawptr,
    value: rawptr,
    hash: u64,
}