package flecs

import "core:c"

BucketEntry :: struct
{
    next: ^BucketEntry,
    key: map_key_t,
}

Bucket :: struct
{
    first: ^BucketEntry,
}

Map :: struct
{
    buckets: [^]Bucket,
    buckets_end: ^Bucket,
    elem_size: c.int16_t,
    bucket_shift: c.uint8_t,
    shared_allocator: bool,
    bucket_count: c.int32_t,
    count: c.int32_t,
    allocator: ^Allocator,
    entry_allocator: ^BlockAllocator,
}

MapIter :: struct
{
    map_t: ^Map,
    bucket: ^Bucket,
    entry: ^BucketEntry,
}

MapParams :: struct
{
    size: size_t,
    allocator: ^Allocator,
    entry_allocator: BlockAllocator,
    initial_count: c.int32_t,
}

MAP_INIT :: proc($T: typeid) -> Map
{
    return {.elem_size = size_of(T)}
}

map_params_init :: proc(params: ^MapParams, allocator: ^Allocator, $T: typeid)
{
    _map_params_init(params, allocator, size_of(T))
}

map_init :: proc(map_t: ^Map, $T: typeid, allocator: ^Allocator, initial_count: c.int32_t)
{
    _map_init(map_t, size_of(T), allocator, initial_count)
}

map_init_w_params :: proc(map_t: ^Map, params: ^MapParams)
{
    _map_init_w_params(map_t, params)
}

map_init_if :: proc(map_t: ^Map, $T: typeid, allocator: ^Allocator, elem_count: c.int32_t)
{
    _map_init_if(map_t, size_of(T), allocator, elem_count)
}

map_init_w_params_if :: proc(map_t: ^Map, params: ^MapParams)
{
    _map_init_w_params_if(map_t, params)
}

map_new :: proc($T: typeid, allocator: ^Allocator, elem_count: c.int32_t) -> ^Map
{
    return _map_new(size_of(T), allocator, elem_count)
}

map_get :: proc(map_t: ^Map, $T: typeid, key: map_key_t) -> ^T
{
    return cast(^T)_map_get(map_t, size_of(T), key)
}

map_get_ptr :: proc(map_t: ^Map, $T: typeid, key: map_key_t) -> ^T
{
    return cast(^T)_map_get_ptr(map_t, key)
}

map_ensure :: proc(map_t: ^Map, $T: typeid, key: map_key_t) -> ^T
{
    return cast(^T)_map_ensure(map_t, size_of(T), key)
}

map_set :: proc(map_t: ^Map, key: map_key_t, payload: rawptr) -> rawptr
{
    return _map_set(map_t, size_of(payload), key, payload)
}

map_next :: proc(iter: ^MapIter, $T: typeid, key: ^map_key_t) -> ^T
{
    return cast(^T)_map_next(iter, size_of(T), key)
}

map_next_ptr :: proc(iter: ^MapIter, $T: typeid, key: ^map_key_t) -> T
{
    return cast(T)_map_next_ptr(iter, key)
}