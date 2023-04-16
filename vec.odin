package flecs

import "core:c"

Vec :: struct
{
    array: rawptr,
    count: i32,
    size: i32,
}

vec_init_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32) -> ^Vec
{
    return vec_init(allocator, vec, size_of(T), elem_count)
}

vec_init_if_t :: proc(vec: ^Vec, $T: typeid)
{
    vec_init_if(vec, size_of(T))
}

vec_fini_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid)
{
    vec_fini(allocator, vec, size_of(T))
}

vec_reset_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> ^Vec
{
    return vec_reset(allocator, vec, size_of(T))
}

vec_append_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_append(allocator, vec, size_of(T))
}

vec_remove_t :: proc(vec: ^Vec, $T: typeid, elem: i32)
{
    vec_remove(vec, size_of(T), elem)
}

vec_copy_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> ^T
{
    return vec_copy(allocator, vec, size_of(T))
}

vec_reclaim_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid)
{
    vec_reclaim(allocator, vec, size_of(T))
}

vec_set_size_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32)
{
    vec_set_size(allocator, vec, size_of(T), elem_count)
}

vec_set_min_size_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32)
{
    vec_set_min_size(allocator, vec, size_of(T), elem_count)
}

vec_set_min_count_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32)
{
    vec_set_min_count(allocator, vec, size_of(T), elem_count)
}

vec_set_count_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32)
{
    vec_set_count(allocator, vec, size_of(T), elem_count)
}

vec_grow_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: i32) -> rawptr
{
    return vec_grow(allocator, vec, size_of(T), elem_count)
}

vec_get_t :: proc(vec: ^Vec, $T: typeid, index: i32) -> ^T
{
    return cast(^T)vec_get(vec, size_of(T), index)
}

vec_first_t :: proc(vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_first(vec)
}

vec_last_t :: proc(vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_last(vec, size_of(T))
}