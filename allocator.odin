package flecs

import "core:c"

Allocator :: struct
{
    chunks: BlockAllocator,
    sizes: Sparse,
}