package flecs

import "core:c"

EntityDesc :: struct
{
    _canary: c.int32_t,
    id: Entity,
    name: cstring,
    sep: cstring,
    root_sep: cstring,
    symbol: cstring,

    use_low_id: bool,
    add: [ID_CACHE_SIZE]id_t,
    add_expr: cstring,
}

BulkDesc :: struct
{
    _canary: c.int32_t,
    entities: [^]Entity,
    count: c.int32_t,

    ids: [ID_CACHE_SIZE]id_t,

    data: [^]rawptr,

    table: ^Table,
}

ComponentDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    type: TypeInfo,
}

FilterDesc :: struct
{
    _canary: c.int32_t,
    terms: [TERM_DESC_CACHE_SIZE]Term,
    terms_buffer: [^]Term,
    terms_buffer_count: c.int32_t,

    storage: ^Filter,

    instanced: bool,
    flags: flags32_t,
    expr: cstring,
    name: cstring,
}

QueryDesc :: struct
{
    _canary: c.int32_t,
    filter: FilterDesc,
    order_by_component: Entity,
    order_by: order_by_action_t,
    sort_table: sort_table_action_t,
    group_by_id: id_t,
    group_by: group_by_action_t,
    on_group_create: group_create_action_t,
    on_group_delete: group_delete_action_t,
    group_by_ctx: rawptr,
    group_by_ctx_free: ctx_free_t,
    parent: ^Query,
    entity: Entity,
}

ObserverDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    filter: FilterDesc,
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    yield_existing: bool,
    callback: iter_action_t,
    run: run_action_t,
    ctx: rawptr,
    binding_ctx: rawptr,
    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,
    observable: ^poly_t,
    last_event_id: ^c.int32_t,
    term_index: c.int32_t,
}

// Builtin components
EcsIdentifier :: struct
{
    value: cstring,
    length: size_t,
    hash: c.uint64_t,
    index_hash: c.uint64_t,
    index: ^Hashmap,
}

EcsComponent :: struct
{
    size: size_t,
    alignment: size_t,
}

EcsPoly :: struct
{
    poly: ^poly_t,
}

EcsIterable :: Iterable

// misc types
Value :: struct
{
    type: Entity,
    ptr: rawptr,
}

WorldInfo :: struct
{
    last_component_id: Entity,
    last_id: Entity,
    min_id: Entity,
    max_id: Entity,

    delta_time_raw: ftime_t,
    delta_time: ftime_t,
    time_scale: ftime_t,
    target_fps: ftime_t,
    frame_time_total: ftime_t,
    system_time_total: ftime_t,
    emit_time_total: ftime_t,
    merge_time_total: ftime_t,
    world_time_total: ftime_t,
    world_time_total_raw: ftime_t,
    rematch_time_total: ftime_t,

    frame_count_total: c.int64_t,
    merge_count_total: c.int64_t,
    rematch_count_total: c.int64_t,

    id_create_total: c.int64_t,
    id_delete_total: c.int64_t,
    table_create_total: c.int64_t,
    table_delete_total: c.int64_t,
    pipeline_build_count_total: c.int64_t,
    systems_ran_frame: c.int64_t,
    observers_ran_frame: c.int64_t,

    id_count: c.int32_t,
    tag_id_count: c.int32_t,
    component_id_count: c.int32_t,
    pair_id_count: c.int32_t,
    wildcard_id_count: c.int32_t,

    table_count: c.int32_t,
    tag_table_count: c.int32_t,
    trivial_table_count: c.int32_t,
    empty_table_count: c.int32_t,
    table_record_count: c.int32_t,
    table_storage_count: c.int32_t,

    cmd: struct
    {
        add_count: c.int64_t,
        remove_count: c.int64_t,
        delete_count: c.int64_t,
        clear_count: c.int64_t,
        set_count: c.int64_t,
        get_mut_count: c.int64_t,
        modified_count: c.int64_t,
        other_count: c.int64_t,
        discard_count: c.int64_t,
        batched_entity_count: c.int64_t,
        batched_command_count: c.int64_t,
    },

    name_prefix: cstring,
}

QueryGroupInfo :: struct
{
    match_count: c.int32_t,
    table_count: c.int32_t,
    ctx: rawptr,
}