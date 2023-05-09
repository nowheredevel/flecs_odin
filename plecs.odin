package flecs

import "core:c"

// Ignore component declare

Ecs_Script :: struct
{
    using_: Vec,
    script: cstring,
    prop_defaults: Vec,
    world: ^World,
}

Script_Desc :: struct
{
    entity: Entity,
    filename: cstring,
    str: cstring,
}

// Ignore convenience macro