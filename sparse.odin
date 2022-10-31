package flecs

import "core:c"

SPARSE_CHUNK_SIZE :: 4096

Sparse :: struct
{
    dense: ^Vector,
    chunks: ^Vector,
    size: size_t,
    count: c.int32_t,
    max_id_local: c.int64_t,
    max_id: ^c.int64_t,
    allocator: ^Allocator,
    chunk_allocator: ^BlockAllocator,
}

sparse_new :: proc($T: typeid) -> ^Sparse
{
    return _sparse_new(size_of(T))
}

sparse_add :: proc(sparse: ^Sparse, $T: typeid) -> ^T
{
    return cast(^T)_sparse_add(sparse, size_of(T))
}

sparse_get_dense :: proc(sparse: ^Sparse, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)_sparse_get_dense(sparse, size_of(T), index)
}

sparse_get :: proc(sparse: ^Sparse, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)_sparse_get(sparse, size_of(T), index)
}