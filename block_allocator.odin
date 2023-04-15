package flecs

import "core:c"

Block_Allocator_Block :: struct
{
    memory: rawptr,
    next: ^Block_Allocator_Block,
}

Block_Allocator_Chunk_Header :: struct
{
    next: ^Block_Allocator_Chunk_Header,
}

Block_Allocator :: struct
{
    head: ^Block_Allocator_Chunk_Header,
    block_head: ^Block_Allocator_Block,
    block_tail: ^Block_Allocator_Block,
    chunk_size: i32,
    data_size: i32,
    chunks_per_block: i32,
    block_size: i32,
    alloc_count: i32,
}

ballocator_init_t :: proc(ba: ^Block_Allocator, $T: typeid)
{
    ballocator_init(ba, size_of(T))
}

ballocator_init_n :: proc(ba: ^Block_Allocator, $T: typeid, count: int)
{
    ballocator_init(ba, size_of(T) * count)
}

ballocator_new_t :: proc($T: typeid) -> ^Block_Allocator
{
    return ballocator_new(size_of(T))
}

ballocator_new_n :: proc($T: typeid, count: int) -> ^Block_Allocator
{
    return ballocator_new(size_of(T) * count)
}