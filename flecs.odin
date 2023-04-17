package flecs

import "core:c"

/// NOTE: This contains bindings to the contents of include/flecs.h, NOT the root flecs.h

FTime :: c.float

when #config(FLECS_LOW_FOOTPRINT, true)
{
    HI_COMPONENT_ID :: 16
    HI_ID_RECORD_ID :: 16
    SPARSE_PAGE_BITS :: 6
    USE_OS_ALLOC :: true
} else
{
    HI_COMPONENT_ID :: 256
    HI_ID_RECORD_ID :: 1024
    SPARSE_PAGE_BITS :: 12
}

ID_CACHE_SIZE :: 32
TERM_DESC_CACHE_SIZE :: 16
OBSERVER_DESC_EVENT_COUNT_MAX :: 8
VARIABLE_COUNT_MAX :: 64

/// API Types

Id :: u64
Entity :: Id

Type :: struct
{
    array: [^]Id,
    count: i32,
}

World :: struct
{
    hdr: Header,

    /// Type metadata
    id_index_lo: ^Id_Record,
    id_index_hi: Map,
    type_info: Sparse,

    /// Cached handle to id records
    idr_wildcard: ^Id_Record,
    idr_wildcard_wildcard: ^Id_Record,
    idr_any: ^Id_Record,
    idr_isa_wildcard: ^Id_Record,
    idr_childof_0: ^Id_Record,
    idr_childof_wildcard: ^Id_Record,
    idr_identifier_name: ^Id_Record,

    /// Mixins
    self: ^World,
    observable: Observable,
    iterable: Iterable,

    /// Unique id
    event_id: i32,

    range_check_enabled: c.bool,
    
    /// Data storage
    store: Store,

    /// Pending table event buffers
    pending_buffer: ^Sparse,
    pending_tables: ^Sparse,

    monitors: Monitor_Set,

    /// Systems
    pipeline: Entity, // Current pipeline

    /// Identifiers
    aliases: HashMap,
    symbols: HashMap,

    /// Staging
    stages: [^]Stage,
    stage_count: i32,

    /// Multithreading
    worker_cond: OS_Cond,
    sync_cond: OS_Cond,
    sync_mutex: OS_Mutex,
    workers_running: i32,
    workers_waiting: i32,

    /// Time management
    world_start_time: Time,
    frame_start_time: Time,
    fps_sleep: FTime,

    /// Metrics
    info: World_Info,

    /// World flags
    flags: Flags32,

    monitor_generation: i32,

    /// Allocators
    allocators: World_Allocators,
    allocator: Allocator,

    context_: rawptr, // Application context
    fini_actions: Vec, // Callbacks to execute when world exits
}

Table :: struct
{
    id: u64,
    type_: Type,
    flags: Flags32,
    storage_count: u16,
    generation: u16,

    records: [^]Table_Record,
    storage_table: ^Table,
    storage_ids: [^]Id,
    storage_map: [^]i32,

    node: Graph_Node,
    data: Data,
    type_info: [^]Type_Info,

    dirty_state: ^i32,

    ext: ^Table_Ext,

    record_count: u16,
    refcount: i32,
    lock: i32,
    observed_count: i32,
}

Term :: struct
{
    id: Id,

    src: Term_Id,
    first: Term_Id,
    second: Term_Id,

    inout: InOut_Kind,
    oper: Oper_Kind,

    id_flags: Id,
    name: cstring,

    field_index: i32,
    idr: ^Id_Record,

    flags: Flags16,

    move: c.bool,
}

Query :: struct
{
    hdr: Header,
    filter: Filter,
    cache: Table_Cache,
    list: Query_Table_List,
    groups: Map,

    /// Table sorting
    order_by_component: Entity,
    order_by: Order_By_Action,
    sort_table: Sort_Table_Action,
    table_slices: Vec,
    order_by_term: i32,

    /// Table grouping
    group_by_id: Entity,
    group_by: Group_By_Action,
    on_group_create: Group_Create_Action,
    on_group_delete: Group_Delete_Action,
    group_by_ctx: rawptr,
    group_by_ctx_free: Ctx_Free,

    /// Subqueries
    parent: ^Query,
    subqueries: Vec,

    /// Flags for query properties
    flags: Flags32,

    /// Monitor generation
    monitor_generation: i32,

    cascade_by: i32,
    match_count: i32,
    prev_match_count: i32,
    rematch_count: i32,

    /// Mixins
    iterable: Iterable,
    dtor: Poly_Dtor,

    /// Query-level allocators
    allocators: Query_Allocators,
}

Filter :: struct
{
    hdr: Header,

    terms: [^]Term,
    term_count: i32,
    field_count: i32,

    owned: c.bool,
    terms_owned: c.bool,

    flags: Flags32,

    variable_names: [1]cstring,
    sizes: [^]i32,

    /// Mixins
    entity: Entity,
    iterable: Iterable,
    dtor: Poly_Dtor,
    world: ^World,
}

// Rule is defined in rules.odin

Observer :: struct
{
    hdr: Header,

    filter: Filter,

    /// Observer events
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    event_count: i32,

    callback: Iter_Action,
    run: Run_Action,

    ctx: rawptr,
    binding_ctx: rawptr,

    ctx_free: Ctx_Free,
    binding_ctx_free: Ctx_Free,

    observable: ^Observable,

    last_event_id: ^i32,
    last_event_id_storage: i32,

    register_id: Id,
    term_index: i32,

    is_monitor: c.bool,

    is_multi: c.bool,

    /// Mixins
    dtor: Poly_Dtor,
}

// Observable is defined in api_types.odin

// Iter is defined in api_types.odin

// Ref is defined in api_types.odin

Type_Hooks :: struct
{
    ctor: Xtor,
    dtor: Xtor,
    copy: Copy,
    move: Move,

    copy_ctor: Copy,
    move_ctor: Move,
    ctor_move_dtor: Move,
    move_dtor: Move,
    
    on_add: Iter_Action,
    on_set: Iter_Action,
    on_remove: Iter_Action,

    ctx: rawptr,
    binding_ctx: rawptr,

    ctx_free: Ctx_Free,
    binding_ctx_free: Ctx_Free,
}

Type_Info :: struct
{
    size: Size,
    alignment: Size,
    hooks: Type_Hooks,
    component: Entity,
    name: cstring,
}

Id_Record :: struct
{
    cache: Table_Cache,
    id: Id,
    flags: Flags32,
    first: Id_Record_Elem,
    second: Id_Record_Elem,
    trav: Id_Record_Elem,
    type_info: ^Type_Info,
    parent: ^Id_Record,
    refcount: i32,
    keep_alive: i32,
    reachable: Reachable_Cache,
    name_index: ^HashMap,
}

Table_Record :: struct
{
    hdr: Table_Cache_Hdr,
    column: i32,
    count: i32,
}

Poly :: c.void

Mixins :: struct
{
    type_name: cstring,
    elems: [Mixin_Kind.Max]Size,
}

Header :: struct
{
    magic: i32,
    type_: i32,
    mixins: ^Mixins,
}

/// Function types
