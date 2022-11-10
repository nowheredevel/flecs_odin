package flecs

import "core:c"
import "core:reflect"
import "core:strings"
import "core:runtime"
import "core:fmt"

@(private)
_GetTypeName :: proc($T: typeid) -> string
{
    ti := type_info_of(T)
    type_name: string

    #partial switch info in ti.variant
    {
        case runtime.Type_Info_Named:
            type_name = info.name
        case:
            fmt.panicf("Error: Tags can only be structs! Received: ", info)
    }

    return type_name
}

TagDefine :: proc(world: ^World, $T: typeid)
{
    desc: EntityDesc

    desc.name = strings.clone_to_cstring(_GetTypeName(T))

    id := entity_init(world, &desc)
}

ComponentDefine :: proc(world: ^World, $T: typeid)
{
    ti := type_info_of(T)

    component_name_c := strings.clone_to_cstring(_GetTypeName(T))
    struct_size := size_of(T)

    edesc: EntityDesc
    edesc.name = component_name_c
    edesc.symbol = component_name_c

    desc: ComponentDesc
    desc.entity = entity_init(world, &edesc)
    desc.type.size = size_of(T)
    desc.type.alignment = align_of(T)
    id := component_init(world, &desc)
}

ObserverDefine :: proc(world: ^World, $T: typeid, kind: Entity, args: ..string)
{
    odesc: ObserverDesc
    edesc: EntityDesc

    name_c := strings.clone_to_cstring(_GetTypeName(T))

    edesc.name = name_c
    edesc.symbol = name_c

    odesc.entity = entity_init(world, &edesc)
    odesc.filter.expr = strings.clone_to_cstring(strings.concatenate(args))
    odesc.events[0] = kind
    id := observer_init(world, &desc)
}

// Function macros

// New


new :: proc(world: ^World, $T: typeid) -> Entity
{
    return new_w_id(world, id(world, T))
}

new_w_pair :: proc(world: ^World, first: Entity, second: Entity) -> Entity
{
    return new_w_id(world, pair(first, second))
}

bulk_new :: proc(world: ^World, $component: typeid, count: c.int32_t) -> ^Entity
{
    cdesc: ComponentDesc
    cdesc.type.size = size_of(component)
    cdesc.type.alignment = align_of(component)

    id := component_init(world, &cdesc)

    return bulk_new_w_id(world, id, count)
}

new_entity :: proc(world: ^World, n: cstring) -> Entity
{
    edesc: EntityDesc
    edesc.name = n
    edesc.symbol = n

    return entity_init(world, &edesc)
}

new_prefab :: proc(world: ^World, n: cstring) -> Entity
{
    edesc: EntityDesc
    edesc.name = n
    edesc.symbol = n
    edesc.add[0] = EcsPrefab

    return entity_init(world, &edesc)
}


// Add


add :: proc(world: ^World, entity: Entity, $T: typeid)
{
    add_id(world, entity, id(world, T))
}

add_pair :: proc(world: ^World, subject: Entity, first: Entity, second: Entity)
{
    add_id(world, subject, pair(first, second))
}


// Remove


remove :: proc(world: ^World, entity: Entity, $T: typeid)
{
    remove_id(world, entity, id(world, T))
}

remove_pair :: proc(world: ^World, subject: Entity, first: Entity, second: Entity)
{
    remove_id(world, subject, pair(first, second))
}


// Override


override :: proc(world: ^World, entity: Entity, $T: typeid)
{
    override_id(world, entity, id(world, T))
}

override_pair :: proc(world: ^World, subject: Entity, first: Entity, second: Entity)
{
    override_id(world, subject, pair(first, second))
}


// Bulk remove/delete


delete_children :: proc(world: ^World, parent: Entity)
{
    delete_with(world, pair(EcsChildOf, parent))
}


// Set


set_ptr :: proc(world: ^World, entity: Entity, $component: typeid, ptr: rawptr) -> Entity
{
    cdesc: ComponentDesc
    cdesc.entity = id(world, component)
    cdesc.type.size = size_of(component)
    cdesc.type.alignment = align_of(component)
    id := component_init(world, &cdesc)

    return set_id(world, entity, id, size_of(component), ptr)
}

set :: proc(world: ^World, entity: Entity, $component: typeid, args: component) -> Entity
{
    cdesc: ComponentDesc
    cdesc.entity = id(world, component)
    cdesc.type.size = size_of(component)
    cdesc.type.alignment = align_of(component)
    id := component_init(world, &cdesc)

    args := args

    return set_id(world, entity, id, size_of(component), &args)
}

set_pair :: proc(world: ^World, subject: Entity, $First: typeid, second: Entity, args: First) -> Entity
{
    cdesc: ComponentDesc
    cdesc.entity = id(world, First)
    cdesc.type.size = size_of(First)
    cdesc.type.alignment = align_of(First)
    id := component_init(world, &cdesc)

    args := args

    return set_id(world, subject, pair(id, second), size_of(First), &args)
}

set_pair_second :: proc(world: ^World, subject: Entity, first: Entity, $Second: typeid, args: Second) -> Entity
{
    cdesc: ComponentDesc
    cdesc.entity = id(world, Second)
    cdesc.type.size = size_of(Second)
    cdesc.type.alignment = align_of(Second)
    id := component_init(world, &cdesc)

    args := args

    return set_id(world, subject, pair(first, id), size_of(Second), &args)
}

set_pair_object :: set_pair_second

set_override :: proc(world: ^World, entity: Entity, $T: typeid, args: T) -> Entity
{
    add_id(world, entity, IdBitFlags.OVERRIDE | id(world, T))
    set(world, entity, T, args)
}


// Emplace


emplace :: proc(world: ^World, entity: Entity, $T: typeid) -> ^T
{
    return cast(^T)emplace_id(world, entity, id(world, T))
}


// Get


get :: proc(world: ^World, entity: Entity, $T: typeid) -> ^T
{
    return cast(^T)get_id(world, entity, id(world, T))
}

get_pair :: proc(world: ^World, subject: Entity, $First: typeid, second: Entity) -> ^First
{
    return cast(^First)get_id(world, subject, pair(id(world, First), second))
}

get_pair_second :: proc(world: ^World, subject: Entity, first: Entity, $Second: typeid) -> ^Second
{
    return cast(^Second)get_id(world, subject, pair(first, id(world, Second)))
}

get_pair_object :: get_pair_second


// Get from record


record_get :: proc(world: ^World, record: ^Record, $T: typeid) -> ^T
{
    return cast(^T)record_get_id(world, record, id(world, T))
}

record_get_pair :: proc(world: ^World, record: ^Record, $First: typeid, second: Entity) -> ^First
{
    return cast(^First)record_get_id(world, record, pair(id(world, First), second))
}

record_get_pair_second :: proc(world: ^World, record: ^Record, first: Entity, $Second: typeid) -> ^Second
{
    return cast(^Second)record_get_id(world, record, pair(first, id(world, Second)))
}


// Ref


ref_init :: proc(world: ^World, entity: Entity, $T: typeid) -> Ref
{
    return ref_init_id(world, entity, id(world, T))
}

ref_get :: proc(world: ^World, ref: ^Ref, $T: typeid) -> ^T
{
    return cast(^T)ref_get_id(world, ref, id(world, T))
}


// Modified


modified :: proc(world: ^World, entity: Entity, $component: typeid)
{
    modified_id(world, entity, id(component))
}

modified_pair :: proc(world: ^World, subject: Entity, first: Entity, second: Entity)
{
    modified_id(world, subject, pair(first, second))
}


// Singletons


singleton_add :: proc(world: ^World, $comp: typeid)
{
    add(world, id(world, comp), comp)
}

singleton_remove :: proc(world: ^World, $comp: typeid)
{
    remove(world, id(world, comp), comp)
}

singleton_get :: proc(world: ^World, $comp: typeid) -> ^comp
{
    return get(world, id(world, comp), comp)
}

singleton_set :: proc(world: ^World, $comp: typeid, args: comp)
{
    set(world, id(world, comp), comp, args)
}

singleton_modified :: proc(world: ^World, $comp: typeid)
{
    modified(world, id(comp), comp)
}


// Has, Owns & Shares


has :: proc(world: ^World, entity: Entity, $T: typeid) -> c.bool
{
    return has_id(world, entity, id(T))
}

has_pair :: proc(world: ^World, entity: Entity, first: Entity, second: Entity) -> c.bool
{
    return has_id(world, entity, pair(first, second))
}

owns_id :: proc(world: ^World, entity: Entity, id: id_t) -> c.bool
{
    return (search(world, get_table(world, entity), id, nil) != -1)
}

owns_pair :: proc(world: ^World, entity: Entity, first: Entity, second: Entity) -> c.bool
{
    return owns_id(world, entity, pair(first, second))
}

owns :: proc(world: ^World, entity: Entity, $T: typeid) -> c.bool
{
    return owns_id(world, entity, id(world, T))
}

shares_id :: proc(world: ^World, entity: Entity, id: id_t) -> c.bool
{
    return (search_relation(world, get_table(world, entity), 0, id, EcsIsA, 1, nil, nil, nil) != -1)
}

shares_pair :: proc(world: ^World, entity: Entity, first: Entity, second: Entity) -> c.bool
{
    return shares_id(world, entity, pair(first, second))
}

shares :: proc(world: ^World, entity: Entity, $T: typeid) -> c.bool
{
    return shares_id(world, entity, id(T))
}


// Enable / Disable component


enable_component :: proc(world: ^World, entity: Entity, $T: typeid, enable: c.bool)
{
    enable_id(world, entity, id(T), enable)
}

is_enabled_component :: proc(world: ^World, entity: Entity, $T: typeid) -> c.bool
{
    return is_enabled_id(world, entity, id(T))
}

enable_pair :: proc(world: ^World, entity: Entity, $First: typeid, second: Entity, enable: c.bool)
{
    enable_id(world, entity, pair(id(First), second), enable)
}

is_enabled_pair :: proc(world: ^World, entity: Entity, $First: typeid, second: Entity) -> c.bool
{
    return is_enabled_id(world, entity, pair(id(First), second))
}


// Count


count :: proc(world: ^World, $type: typeid) -> c.int32_t
{
    return count_id(world, id(type))
}


// Lookups & Paths


lookup_path :: proc(world: ^World, parent: Entity, path: cstring) -> Entity
{
    return lookup_path_w_sep(world, parent, path, ".", nil, true)
}

lookup_fullpath :: proc(world: ^World, path: cstring) -> Entity
{
    return lookup_path_w_sep(world, 0, path, ".", nil, true)
}

get_path :: proc(world: ^World, parent: Entity, child: Entity) -> cstring
{
    return get_path_w_sep(world, parent, child, ".", nil)
}

get_fullpath :: proc(world: ^World, child: Entity) -> cstring
{
    return get_path_w_sep(world, 0, child, ".", nil)
}

get_fullpath_buf :: proc(world: ^World, child: Entity, buf: ^StrBuf)
{
    get_path_w_sep_buf(world, 0, child, ".", nil, buf)
}

new_from_path :: proc(world: ^World, parent: Entity, path: cstring) -> Entity
{
    return new_from_path_w_sep(world, parent, path, ".", nil)
}

new_from_fullpath :: proc(world: ^World, path: cstring) -> Entity
{
    return new_from_path_w_sep(world, 0, path, ".", nil)
}

add_path :: proc(world: ^World, entity: Entity, parent: Entity, path: cstring) -> Entity
{
    return add_path_w_sep(world, entity, parent, path, ".", nil)
}

add_fullpath :: proc(world: ^World, entity: Entity, path: cstring) -> Entity
{
    return add_path_w_sep(world, entity, 0, path, ".", nil)
}


// Iterators


field :: proc(it: ^Iter, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)field_w_size(it, size_of(T), index)
}

iter_column :: proc(it: ^Iter, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)iter_column_w_size(it, size_of(T), index)
}


// Utility macros


isa :: proc(e: Entity) -> Entity
{
    return pair(EcsIsA, e)
}

childof :: proc(e: Entity) -> Entity
{
    return pair(EcsChildOf, e)
}

dependson :: proc(e: Entity) -> Entity
{
    return pair(EcsDependsOn, e)
}

value :: proc(world: ^World, $T: typeid, ptr: rawptr) -> Value
{
    v: Value
    v.type = id(world, T)
    v.ptr = ptr
    return v
}

value_new_t :: proc(world: ^World, $T: typeid) -> rawptr
{
    return value_new(world, id(world, T))
}

query_new :: proc(world: ^World, q_expr: cstring) -> ^Query
{
    q: QueryDesc
    q.filter.expr = q_expr

    return query_init(world, &q)
}

rule_new :: proc(world: ^World, q_expr: cstring) -> ^Rule
{
    f: FilterDesc
    f.expr = q_expr

    // TODO: FIX
    return {}
    //return rule_init(world, &f)
}