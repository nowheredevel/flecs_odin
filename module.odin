package flecs

import "core:c"

MODULE_DEFINE :: proc(world: ^World, id: Entity, name: cstring)
{
    desc: Component_Desc = {}
    desc.entity = id
    id := id
    id = module_init(world, name, &desc)
    set_scope(world, id)
}

MODULE :: proc(world: ^World, name: cstring)
{
    id := new_id(world)
    MODULE_DEFINE(world, id, name)
}

IMPORT :: proc(world: ^World, module: Module_Action, name: cstring) -> Entity
{
    return import_c(world, module, name)
}