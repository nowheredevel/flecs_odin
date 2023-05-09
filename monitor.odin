package flecs

import "core:c"

// Ignore component declarations

Ecs_Stats_Header :: struct
{
    elapsed: FTime,
    reduce_count: i32,
}

Ecs_World_Stats :: struct
{
    hdr: Ecs_Stats_Header,
    stats: World_Stats,
}

Ecs_Pipeline_Stats :: struct
{
    hdr: Ecs_Stats_Header,
    stats: Pipeline_Stats,
}