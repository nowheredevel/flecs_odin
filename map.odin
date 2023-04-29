package flecs

import "core:c"

Map_Data :: u64
Map_Key :: Map_Data
Map_Val :: Map_Data

Bucket_Entry :: struct
{
    key: Map_Key,
    value: Map_Val,
    next: ^Bucket_Entry,
}

Bucket :: struct
{
    first: ^Bucket_Entry,
}

Map :: struct
{
    bucket_shift: u8,
    shared_allocator: c.bool,
    buckets: [^]Bucket,
    bucket_count: i32,
    count: i32,
    entry_allocator: ^Block_Allocator,
    allocator: ^Allocator,
}

Map_Iter :: struct
{
    map_: ^Map,
    bucket: ^Bucket,
    entry: ^Bucket_Entry,
    res: [^]Map_Data,
}

Map_Params :: struct
{
    allocator: ^Allocator,
    entry_allocator: Block_Allocator,
}

map_count :: proc(map_: Map) -> i32
{
    return map_.count
}

map_is_init :: proc(map_: Map) -> bool
{
    return (map_).bucket_shift != 0
}

map_get_ref :: proc(m: ^Map, $T: typeid, k: Map_Key) -> [^]T
{
    return cast([^]T)map_get(m, k)
}

map_get_deref :: proc(m: ^Map, $T: typeid, k: Map_Key) -> ^T
{
    return cast(^T)_map_get_deref(m, k)
}

map_ensure_ref :: proc(m: ^Map, $T: typeid, k: Map_Key) -> [^]T
{
    return cast([^]T)map_ensure(m, k)
}

map_insert_ptr :: proc(m: ^Map, k: Map_Key, v: int)
{
    map_insert(m, k, cast(Map_Val)v)
}

map_insert_alloc_t :: proc(m: ^Map, $T: typeid, k: Map_Key) -> ^T
{
    return cast(^T)map_insert_alloc(m, size_of(T), k)
}

map_ensure_alloc_t :: proc(m: ^Map, $T: typeid, k: Map_Key) -> ^T
{
    return cast(^T)map_ensure_alloc(m, size_of(T), k)
}

// TODO: Fix this
/*
map_remove_ptr :: proc(m: ^Map, k: Map_Key) -> rawptr
{
    return cast(rawptr)map_remove(m, k)
}
*/

map_key :: proc(it: ^Map_Iter) -> Map_Data
{
    return it.res[0]
}

map_value :: proc(it: ^Map_Iter) -> Map_Data
{
    return it.res[1]
}

// TODO: Fix this
/*
map_ptr :: proc(it: ^Map_Iter) -> rawptr
{
    return cast(rawptr)map_value(it)
}
*/

map_ref :: proc(it: ^Map_Iter, $T: typeid) -> [^]T
{
    return cast([^]T)(&(it->res[1]))
}