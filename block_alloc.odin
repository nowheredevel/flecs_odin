package flecs

import "core:c"

BlockAllocatorBlock :: struct
{
    memory: rawptr,
    next: ^BlockAllocatorBlock,
}

BlockAllocatorChunkHeader :: struct
{
    next: ^BlockAllocatorChunkHeader,
}

BlockAllocator :: struct
{
    head: ^BlockAllocatorChunkHeader,
    block_head: ^BlockAllocatorBlock,
    block_tail: ^BlockAllocatorBlock,
    chunk_size: c.int32_t,
    data_size: c.int32_t,
    chunks_per_block: c.int32_t,
    block_size: c.int32_t,
    alloc_count: c.int32_t,
}