package flecs

import "core:c"

REST_DEFAULT_PORT :: 27750

EcsRest :: struct
{
    port: c.uint16_t,
    ipaddr: cstring,
    impl: rawptr,
}

GetEcsRest :: proc(world: ^World) -> Entity
{
    return id(world, EcsRest)
}