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

/** NOTE: In flecs, ecs_poly_t is a type alias to a void. However,
* Odin doesn't have a void type, the closest is rawptr but that's
* actually a pointer to a void. Luckily, whenever poly is used in
* flecs, it's always used as a pointer to poly, so in flecs_odin
* we store Poly as a rawptr and never store pointers to Poly, just
* Poly itself.
*/
Poly :: rawptr

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
Run_Action :: #type proc "c" (it: ^Iter)
Iter_Action :: #type proc "c" (it: ^Iter)
Iter_Init_Action :: #type proc "c" (world: ^World, iterable: Poly, it: ^Iter, filter: ^Term)
Iter_Next_Action :: #type proc "c" (it: ^Iter) -> c.bool
Iter_Fini_Action :: #type proc "c" (it: ^Iter)

Order_By_Action :: #type proc "c" (
    e1: Entity, 
    ptr1: rawptr, 
    e2: Entity, 
    ptr2: rawptr,
) -> c.int

Sort_Table_Action :: #type proc "c" (
    world: ^World,
    table: ^Table,
    entities: [^]Entity,
    ptr: rawptr,
    size: i32,
    lo: i32,
    hi: i32,
    order_by: Order_By_Action,
)

Group_By_Action :: #type proc "c" (
    world: ^World,
    table: ^Table,
    group_id: Id,
    ctx: rawptr,
) -> u64

Group_Create_Action :: #type proc "c" (
    world: ^World,
    group_id: u64,
    group_by_ctx: rawptr,
) -> rawptr

Group_Delete_Action :: #type proc "c" (
    world: ^World,
    group_id: u64,
    group_ctx: rawptr,
    group_by_ctx: rawptr,
)

Module_Action :: #type proc "c" (world: ^World)

Fini_Action :: #type proc "c" (world: ^World, ctx: rawptr)

Ctx_Free :: #type proc "c" (ctx: rawptr)

Compare_Action :: #type proc "c" (ptr1: rawptr, ptr2: rawptr) -> c.int

Hash_Value_Action :: #type proc "c" (ptr: rawptr) -> u64

Xtor :: #type proc "c" (ptr: rawptr, count: i32, type_info: ^Type_Info)

Copy :: #type proc "c" (
    dst_ptr: rawptr,
    src_ptr: rawptr,
    count: i32,
    type_info: ^Type_Info,
)

Move :: #type proc "c" (
    dst_ptr: rawptr,
    src_ptr: rawptr,
    count: i32,
    type_info: ^Type_Info,
)

Poly_Dtor :: #type proc "c" (poly: Poly)

Iterable :: struct
{
    init: Iter_Init_Action,
}

InOut_Kind :: enum
{
    InOut_Default,
    InOut_None,
    InOut,
    In,
    Out,
}

Oper_Kind :: enum
{
    And,
    Or,
    Not,
    Optional,
    And_From,
    Or_From,
    Not_From,
}

Term_Id_Flags :: enum u32
{
    Self = 1 << 1,
    Up = 1 << 2,
    Down = 1 << 3,
    Traverse_All = 1 << 4,
    Cascade = 1 << 5,
    Parent = 1 << 6,
    Is_Variable = 1 << 7,
    Is_Entity = 1 << 8,
    Is_Name = 1 << 9,
    Filter = 1 << 10,
    Traverse_Flags = (Up|Down|Traverse_All|Self|Cascade|Parent),
}

Term_Flags :: enum
{
    Match_Any = 1 << 0,
    Match_Any_Src = 1 << 1,
    Src_First_Eq = 1 << 2,
    Src_Second_Eq = 1 << 3,
    Transitive = 1 << 4,
    Reflexive = 1 << 5,
    Id_Inherited = 1 << 6,
}

Term_Id :: struct
{
    id: Entity,
    name: cstring,
    trav: Entity,
    flags: Flags32,
}

// Term already defined

FILTER_INIT : Filter : {hdr = {magic = 0x65637366}}

// Filter already defined

// Observer already defined

// Type_Hooks already defined

// Type_Info already defined

Entity_Desc :: struct
{
    _canary: i32,
    id: Entity,
    name: cstring,
    sep: cstring,
    root_sep: cstring,
    symbol: cstring,
    use_low_id: c.bool,
    add: [ID_CACHE_SIZE]Id,
    add_expr: cstring,
}

Bulk_Desc :: struct
{
    _canary: i32,
    entities: [^]Entity,
    count: i32,
    ids: [ID_CACHE_SIZE]Id,
    data: [^]rawptr,
    table: ^Table,
}

Component_Desc :: struct
{
    _canary: i32,
    entity: Entity,
    type_: Type_Info,
}

Filter_Desc :: struct
{
    _canary: i32,
    terms: [TERM_DESC_CACHE_SIZE]Term,
    terms_buffer: [^]Term,
    terms_buffer_count: i32,
    storage: ^Filter,
    instanced: c.bool,
    flags: Flags32,
    expr: cstring,
    entity: Entity,
}

Query_Desc :: struct
{
    _canary: i32,
    filter: Filter_Desc,
    order_by_component: Entity,
    order_by: Order_By_Action,
    sort_table: Sort_Table_Action,
    group_by_id: Id,
    group_by: Group_By_Action,
    on_group_create: Group_Create_Action,
    on_group_delete: Group_Delete_Action,
    group_by_ctx: rawptr,
    group_by_ctx_free: Ctx_Free,
    parent: ^Query,
}

Observer_Desc :: struct
{
    _canary: i32,
    entity: Entity,
    filter: Filter_Desc,
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    yield_existing: c.bool,
    callback: Iter_Action,
    run: Run_Action,
    ctx: rawptr,
    binding_ctx: rawptr,
    ctx_free: Ctx_Free,
    binding_ctx_free: Ctx_Free,
    observable: Poly,
    last_event_id: ^i32,
    term_index: i32,
}

Value :: struct
{
    type_: Entity,
    ptr: rawptr,
}

World_Info :: struct
{
    last_component_id: Entity,
    last_id: Entity,
    min_id: Entity,
    max_id: Entity,

    delta_time_raw: FTime,
    delta_time: FTime,
    time_scale: FTime,
    target_fps: FTime,
    frame_time_total: FTime,
    system_time_total: FTime,
    emit_time_total: FTime,
    merge_time_total: FTime,
    world_time_total: FTime,
    world_time_total_raw: FTime,
    rematch_time_total: FTime,

    frame_count_total: i64,
    merge_count_total: i64,
    rematch_count_total: i64,

    id_create_total: i64,
    id_delete_total: i64,
    table_create_total: i64,
    table_delete_total: i64,
    pipeline_build_count_total: i64,
    systems_ran_frame: i64,
    observers_ran_frame: i64,

    id_count: i32,
    tag_id_count: i32,
    component_id_count: i32,
    pair_id_count: i32,
    wildcard_id_count: i32,

    table_count: i32,
    tag_table_count: i32,
    trivial_table_count: i32,
    empty_table_count: i32,
    table_record_count: i32,
    table_storage_count: i32,

    cmd: struct {
        add_count: i64,
        remove_count: i64,
        delete_count: i64,
        clear_count: i64,
        set_count: i64,
        get_mut_count: i64,
        modified_count: i64,
        other_count: i64,
        discard_count: i64,
        batched_entity_count: i64,
        batched_command_count: i64,
    },

    name_prefix: cstring,
}

Query_Group_Info :: struct
{
    match_count: i32,
    table_count: i32,
    ctx: rawptr,
}

/// Builtin components

Ecs_Identifier :: struct
{
    value: cstring,
    length: Size,
    hash: u64,
    index_hash: u64,
    index: ^HashMap,
}

Ecs_Component :: struct
{
    size: Size,
    alignment: Size,
}

Ecs_Poly :: struct
{
    poly: Poly,
}

Ecs_Target :: struct
{
    count: i32,
    target: ^Record,
}

Ecs_Iterable :: Iterable

/// Builtin component IDs

// TODO: Remove this code if the defs in procs.odin work, uncomment otherwise
Ecs_Component_Id : Entity : 1
Ecs_Identifier_Id : Entity : 2
Ecs_Iterable_Id : Entity : 3
Ecs_Poly_Id : Entity : 4

/// System module component IDs

//Ecs_System : Entity : 7
Ecs_Tick_Source_Id : Entity : HI_COMPONENT_ID + 47

/// Pipeline module component IDs

// ecs_id(EcsPipelineQuery) has no definition so...

/// Timer module component IDs

Ecs_Timer_Id : Entity : HI_COMPONENT_ID + 48
Ecs_Rate_Filter_Id : Entity : HI_COMPONENT_ID + 49

/// More builtin entities that I will not individually comment :P

Ecs_Flecs : Entity : HI_COMPONENT_ID + 1
Ecs_Flecs_Core : Entity : HI_COMPONENT_ID + 2
Ecs_World : Entity : HI_COMPONENT_ID + 0
Ecs_Wildcard : Entity : HI_COMPONENT_ID + 10
Ecs_Any : Entity : HI_COMPONENT_ID + 11
Ecs_This : Entity : HI_COMPONENT_ID + 12
Ecs_Variable : Entity : HI_COMPONENT_ID + 13
Ecs_Transitive : Entity : HI_COMPONENT_ID + 14
Ecs_Reflexive : Entity : HI_COMPONENT_ID + 15
Ecs_Final : Entity : HI_COMPONENT_ID + 17
Ecs_Dont_Inherit : Entity : HI_COMPONENT_ID + 18
Ecs_Always_Override : Entity : HI_COMPONENT_ID + 19
Ecs_Symmetric : Entity : HI_COMPONENT_ID + 16
Ecs_Exclusive : Entity : HI_COMPONENT_ID + 22
Ecs_Acyclic : Entity : HI_COMPONENT_ID + 23
Ecs_Traversable : Entity : HI_COMPONENT_ID + 24
Ecs_With : Entity : HI_COMPONENT_ID + 25
Ecs_One_Of : Entity : HI_COMPONENT_ID + 26
Ecs_Tag : Entity : HI_COMPONENT_ID + 20
Ecs_Union : Entity : HI_COMPONENT_ID + 21

Ecs_Name : Entity : HI_COMPONENT_ID + 30
Ecs_Symbol : Entity : HI_COMPONENT_ID + 31
Ecs_Alias : Entity : HI_COMPONENT_ID + 32

Ecs_Child_Of : Entity : HI_COMPONENT_ID + 27
Ecs_Is_A : Entity : HI_COMPONENT_ID + 28
Ecs_Depends_On : Entity : HI_COMPONENT_ID + 29

Ecs_Slot_Of : Entity : HI_COMPONENT_ID + 8

Ecs_Module : Entity : HI_COMPONENT_ID + 4
Ecs_Private : Entity : HI_COMPONENT_ID + 5
Ecs_Prefab : Entity : HI_COMPONENT_ID + 6
Ecs_Disabled : Entity : HI_COMPONENT_ID + 7

Ecs_On_Add : Entity : HI_COMPONENT_ID + 33
Ecs_On_Remove : Entity : HI_COMPONENT_ID + 34
Ecs_On_Set : Entity : HI_COMPONENT_ID + 35
Ecs_Un_Set : Entity : HI_COMPONENT_ID + 36

Ecs_Monitor : Entity : HI_COMPONENT_ID + 61

Ecs_On_Delete : Entity : HI_COMPONENT_ID + 37
Ecs_On_Table_Create : Entity : HI_COMPONENT_ID + 38
Ecs_On_Table_Delete : Entity : HI_COMPONENT_ID + 39
Ecs_On_Table_Empty : Entity : HI_COMPONENT_ID + 40
Ecs_On_Table_Fill : Entity : HI_COMPONENT_ID + 41
Ecs_On_Delete_Target : Entity : HI_COMPONENT_ID + 46

Ecs_Remove : Entity : HI_COMPONENT_ID + 50
Ecs_Delete : Entity : HI_COMPONENT_ID + 51
Ecs_Panic : Entity : HI_COMPONENT_ID + 52

Ecs_Target_Id : Entity : HI_COMPONENT_ID + 53
Ecs_Flatten : Entity : HI_COMPONENT_ID + 54
Ecs_Default_Child_Component : Entity : HI_COMPONENT_ID + 55

Ecs_Pred_Eq : Entity : HI_COMPONENT_ID + 56
Ecs_Pred_Match : Entity : HI_COMPONENT_ID + 57
Ecs_Pred_Lookup : Entity : HI_COMPONENT_ID + 58

Ecs_Empty : Entity : HI_COMPONENT_ID + 62
Ecs_Pipeline_Id : Entity : HI_COMPONENT_ID + 63
Ecs_On_Start : Entity : HI_COMPONENT_ID + 64
Ecs_Pre_Frame : Entity : HI_COMPONENT_ID + 65
Ecs_On_Load : Entity : HI_COMPONENT_ID + 66
Ecs_Post_Load : Entity : HI_COMPONENT_ID + 67
Ecs_Pre_Update : Entity : HI_COMPONENT_ID + 68
Ecs_On_Update : Entity : HI_COMPONENT_ID + 69
Ecs_On_Validate : Entity : HI_COMPONENT_ID + 70
Ecs_Post_Update : Entity : HI_COMPONENT_ID + 71
Ecs_Pre_Store : Entity : HI_COMPONENT_ID + 72
Ecs_On_Store : Entity : HI_COMPONENT_ID + 73
Ecs_Post_Frame : Entity : HI_COMPONENT_ID + 74
Ecs_Phase : Entity : HI_COMPONENT_ID + 75

Ecs_Last_Internal_Component_Id :: Ecs_Poly_Id

Ecs_First_User_Component_Id :: 8

Ecs_First_User_Entity_Id :: HI_COMPONENT_ID + 128

Flatten_Desc :: struct
{
    keep_names: c.bool,
    lose_depth: c.bool,
}

Event_Desc :: struct
{
    event: Entity,
    ids: ^Type,
    table: ^Table,
    other_table: ^Table,
    offset: i32,
    count: i32,
    entity: Entity,
    param: rawptr,
    observable: Poly,
    flags: Flags32,
}