package flecs

import "core:c"

Time :: struct
{
    sec: c.uint32_t,
    nanosec: c.uint32_t,
}