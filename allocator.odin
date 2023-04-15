package flecs

import "core:c"

Allocator :: struct
{
    chunks: Block_Allocator,
    sizes: Sparse,
}

// Ignore flecs_allocator

// TODO: Allocator macros