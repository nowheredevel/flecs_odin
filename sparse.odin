package flecs

import "core:c"

SPARSE_PAGE_SIZE :: 1 << SPARSE_PAGE_BITS

Sparse :: struct
{
    dense: Vec,
    pages: Vec,
    size: Size,
    count: i32,
    max_id_local: u64,
    max_id: ^u64,
    allocator: ^Allocator,
    page_allocator: ^Block_Allocator,
}

sparse_init_t :: proc(sparse: ^Sparse, $T: typeid)
{
    sparse_init(sparse, size_of(T))
}

sparse_add_t :: proc(sparse: ^Sparse, $T: typeid) -> ^T
{
    return cast(^T)sparse_add(sparse, size_of(T))
}

sparse_get_dense_t :: proc(sparse: ^Sparse, $T: typeid, index: i32) -> ^T
{
    return cast(^T)sparse_get_dense(sparse, size_of(T), index)
}

sparse_get_t :: proc(sparse: ^Sparse, $T: typeid, index: i32) -> ^T
{
    return cast(^T)sparse_get(sparse, size_of(T), index)
}