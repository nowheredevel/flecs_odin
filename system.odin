package flecs

import "core:c"
import "core:strings"
import "core:reflect"

EcsTickSource :: struct
{
    tick: c.bool,
    time_elapsed: ftime_t,
}

SystemDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    query: QueryDesc,
    run: run_action_t,
    callback: iter_action_t,
    ctx: rawptr,
    binding_ctx: rawptr,
    
    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,

    interval: ftime_t,
    rate: c.int32_t,
    tick_source: Entity,
    multi_threaded: c.bool,
    no_staging: c.bool,
}

SystemDefine :: proc(world: ^World, func: iter_action_t, phase: c.uint64_t, $args: ..typeid)
{
    sdesc: SystemDesc
    edesc: EntityDesc

    sdesc.entity = entity_init(world, &edesc)
    sdesc.query.filter.expr = args
    sdesc.callback = func
    id := system_init(world, &sdesc)
}