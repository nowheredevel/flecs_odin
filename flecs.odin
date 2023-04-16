package flecs

import "core:c"

/// NOTE: This contains bindings to the contents of include/flecs.h, NOT the root flecs.h

FTime :: c.float

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

    sw_count: i16,
    sw_offset: i16,
    bs_count: i16,
    bs_offset: i16,
    ft_offset: i16,

    record_count: u16,
    refcount: i32,
    lock: i32,
    observed_count: i32,
}