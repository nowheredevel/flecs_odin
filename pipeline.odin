package flecs

import "core:c"
import "core:strings"

PipelineDesc :: struct
{
    entity: Entity,
    query: QueryDesc,
}

PipelineDefine :: proc(world: ^World, $T: typeid, args: ..string)
{
    pdesc: PipelineDesc
    edesc: EntityDesc

    comp_name_c := _GetTypeName(T)

    edesc.name = comp_name_c
    edesc.symbol = comp_name_c

    pdesc.entity = entity_init(world, &edesc)
    pdesc.query.filter.expr = strings.clone_to_cstring(strings.concatenate(args))

    id := pipeline_init(world, &pdesc)
}

pipeline :: proc(world: ^World, desc: PipelineDesc) -> Entity
{
    desc := desc
    return pipeline_init(world, &desc)
}