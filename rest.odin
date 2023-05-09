package flecs

import "core:c"

REST_DEFAULT_PORT :: 27750

Ecs_Rest_Id : Entity : HI_COMPONENT_ID + 116

Ecs_Rest :: struct
{
    port: u16,
    ipaddr: cstring,
    impl: rawptr,
}