package flecs

import "core:c"

Bitset :: struct
{
    data: [^]c.uint64_t,
    count: c.int32_t,
    size: size_t,
}