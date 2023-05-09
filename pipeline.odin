package flecs

import "core:c"
import "core:reflect"

PIPELINE_DEFINE :: proc(world: ^World, id: Entity, name: cstring, args: cstring)
{
    desc: Pipeline_Desc = {}
    edesc: Entity_Desc = {}
    edesc.id = id
    edesc.name = name
    desc.entity = entity_init(world, &edesc)
    desc.query.filter.expr = args
    id := pipeline_init(world, &desc)
    assert_out, valid := reflect.as_string(INVALID_PARAMETER)
    assert(id != 0, assert_out)
}

PIPELINE :: proc(world: ^World, id: Entity, name: cstring, args: cstring)
{
    id: Entity = 0
    PIPELINE_DEFINE(world, id, name, args)
}

// Ignore convenience macro

Pipeline_Desc :: struct
{
    entity: Entity,
    query: Query_Desc,
}