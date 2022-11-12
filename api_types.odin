package flecs

import "core:c"

poly_t :: rawptr

id_t :: c.uint64_t

// Breaks style rules
Entity :: id_t

Type :: struct
{
    array: [^]id_t,
    count: c.int32_t,
}

World :: struct
{
    hdr: Header,

    // Metadata
    id_index: Map,
    type_info: ^Sparse,

    // Cached id to id records
    idr_wildcard: ^IdRecord,
    idr_wildcard_wildcard: ^IdRecord,
    idr_any: ^IdRecord,
    idr_isa_wildcard: ^IdRecord,
    idr_childof_0: ^IdRecord,

    self: ^World,
    observable: Observable,
    iterable: Iterable,

    event_id: c.int32_t,
    range_check_enabled: bool,
    store: Store,

    pending_buffer: ^Sparse,
    pending_tables: ^Sparse,

    monitors: MonitorSet,
    pipeline: Entity,

    aliases: Hashmap,
    symbols: Hashmap,

    stages: ^Stage,
    stage_count: c.int32_t,

    worker_cond: os_cond_t,
    sync_cond: os_cond_t,
    sync_mutex: os_mutex_t,
    workers_running: c.int32_t,
    workers_waiting: c.int32_t,

    world_start_time: Time,
    frame_start_time: Time,
    fps_sleep: ftime_t,

    info: WorldInfo,
    flags: flags32_t,

    allocators: WorldAllocators,
    allocator: Allocator,

    _context: rawptr,
    fini_actions: [^]Vector,
}

Table :: struct
{
    id: c.uint64_t,
    type: Type,
    flags: flags32_t,
    storage_count: c.uint16_t,
    generation: c.uint16_t,

    records: [^]TableRecord,
    storage_table: ^Table,
    storage_ids: [^]id_t,
    storage_map: [^]c.int32_t,

    node: GraphNode,
    data: Data,
    type_info: [^][^]TypeInfo,

    dirty_state: ^c.int32_t,

    sw_count: c.int16_t,
    sw_offset: c.int16_t,
    bs_count: c.int16_t,
    bs_offset: c.int16_t,

    refcount: c.int32_t,
    lock: c.int32_t,
    observed_count: c.int32_t,
    record_count: c.uint16_t,
}

Term :: struct
{
    id: id_t,

    src: TermId,
    first: TermId,
    second: TermId,

    inout: InOutKind,
    oper: OperKind,

    id_flags: id_t,
    name: cstring,

    field_index: c.int32_t,

    move: bool,
}

Query :: struct
{
    hdr: Header,

    filter: Filter,
    cache: TableCache,
    list: QueryTableList,
    groups: Map,
    order_by_component: Entity,
    order_by: order_by_action_t,
    sort_table: sort_table_action_t,
    table_slices: [^]Vector,

    group_by_id: Entity,
    group_by: group_by_action_t,
    on_group_create: group_create_action_t,
    on_group_delete: group_delete_action_t,
    group_by_ctx: rawptr,
    group_by_ctx_free: ctx_free_t,

    parent: ^Query,
    subqueries: [^]Vector,

    flags: flags32_t,
    cascade_by: c.int32_t,
    match_count: c.int32_t,
    prev_match_count: c.int32_t,
    rematch_count: c.int32_t,

    world: ^World,
    iterable: ^Iterable,
    dtor: poly_dtor_t,
    entity: Entity,

    allocators: QueryAllocators,
}

Filter :: struct
{
    hdr: Header,

    terms: [^]Term,
    term_count: c.int32_t,
    field_count: c.int32_t,

    owned: bool,
    terms_owned: bool,

    flags: flags32_t,

    name: cstring,
    variable_names: [1]cstring,
    iterable: Iterable,
}

Rule :: struct
{
    hdr: Header,

    world: ^World,
    operations: ^RuleOp,
    filter: Filter,
    vars: [RULE_MAX_VAR_COUNT]RuleVar,
    var_names: [RULE_MAX_VAR_COUNT]cstring,
    term_vars: [RULE_MAX_VAR_COUNT]RuleTermVars,
    var_eval_order: [RULE_MAX_VAR_COUNT]c.int32_t,

    var_count: c.int32_t,
    subj_var_count: c.int32_t,
    frame_count: c.int32_t,
    operation_count: c.int32_t,

    iterable: Iterable,
}

Observer :: struct
{
    hdr: Header,
    filter: Filter,
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    event_count: c.int32_t,
    callback: iter_action_t,
    run: run_action_t,

    ctx: rawptr,
    binding_ctx: rawptr,

    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,

    observable: ^Observable,
    last_event_id: ^c.int32_t,
    register_id: id_t,
    term_index: c.int32_t,

    is_monitor: bool,
    is_multi: bool,

    world: ^World,
    entity: Entity,
    dtor: poly_dtor_t,
}

Observable :: struct
{
    events: ^Sparse,
}

Iter :: struct
{
    world: ^World,
    real_world: ^World,

    entities: [^]Entity,
    ptrs: [^]rawptr,
    sizes: [^]size_t,
    table: ^Table,
    other_table: ^Table,
    ids: [^]id_t,
    variables: [^]Var,
    columns: [^]c.int32_t,
    sources: [^]Entity,
    match_indices: [^]c.int32_t,

    references: [^]Ref,
    constrained_vars: flags64_t,
    group_id: c.uint64_t,
    field_count: c.int32_t,

    system: Entity,
    event: Entity,
    event_id: id_t,

    terms: [^]Term,
    table_count: c.int32_t,
    term_index: c.int32_t,
    variable_count: c.int32_t,
    variable_names: [^]cstring,

    param: rawptr,
    ctx: rawptr,
    binding_ctx: rawptr,

    delta_time: ftime_t,
    delta_system_time: ftime_t,

    frame_offset: c.int32_t,
    offset: c.int32_t,
    count: c.int32_t,
    instance_count: c.int32_t,

    flags: flags32_t,
    interrupted_by: Entity,
    priv: IterPrivate,

    next: iter_next_action_t,
    callback: iter_action_t,
    fini: iter_fini_action_t,
    chain_it: ^Iter,
}

Ref :: struct
{
    entity: Entity,
    id: Entity,
    tr: ^TableRecord,
    record: ^Record,
}

TypeHooks :: struct
{
    ctor: xtor_t,
    dtor: xtor_t,
    copy: copy_t,
    move: move_t,

    copy_ctor: copy_t,
    move_ctor: move_t,
    ctor_move_dtor: move_t,
    move_dtor: move_t,
    
    on_add: iter_action_t,
    on_set: iter_action_t,
    on_remove: iter_action_t,

    ctx: rawptr,
    binding_ctx: rawptr,

    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,
}

TypeInfo :: struct
{
    size: size_t,
    alignment: size_t,
    hooks: TypeHooks,
    component: Entity,
    name: cstring,
}

Mixins :: struct
{
    type_name: cstring,
    elems: [MixinKind.Max]size_t,
}

// API constants
ID_CACHE_SIZE :: 32
TERM_DESC_CACHE_SIZE :: 16
OBSERVER_DESC_EVENT_COUNT_MAX :: 8
VARIABLE_COUNT_MAX :: 64

// Function Prototypes
run_action_t :: #type proc "c" (it: ^Iter)
iter_action_t :: #type proc (it: ^Iter)
iter_init_action_t :: #type proc "c" (world: ^World, iterable: ^poly_t, it: ^Iter, filter: ^Term)
iter_next_action_t :: #type proc "c" (it: ^Iter) -> c.bool
iter_fini_action_t :: #type proc "c" (it: ^Iter)
order_by_action_t :: #type proc "c" (e1: Entity, ptr1: rawptr, e2: Entity, ptr2: rawptr) -> c.int
sort_table_action_t :: #type proc "c" (world: ^World, table: ^Table, entities: [^]Entity, ptr: rawptr, size: c.int32_t, lo: c.int32_t, hi: c.int32_t, order_by: order_by_action_t)
group_by_action_t :: #type proc "c" (world: ^World, table: ^Table, group_id: id_t, ctx: rawptr) -> c.uint64_t
group_create_action_t :: #type proc "c" (world: ^World, group_id: c.uint64_t, group_by_ctx: rawptr) -> rawptr
group_delete_action_t :: #type proc "c" (world: ^World, group_id: c.uint64_t, group_ctx: rawptr, group_by_ctx: rawptr)
module_action_t :: #type proc "c" (world: ^World)
fini_action_t :: #type proc "c" (world: ^World, ctx: rawptr)
ctx_free_t :: #type proc "c" (ctx: rawptr)
compare_action_t :: #type proc "c" (ptr1: rawptr, ptr2: rawptr) -> c.int
hash_value_action_t :: #type proc "c" (ptr: rawptr) -> c.uint64_t
xtor_t :: #type proc "c" (ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
copy_t :: #type proc "c" (dst_ptr: rawptr, src_ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
move_t :: #type proc "c" (dst_ptr: rawptr, src_ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
poly_dtor_t :: #type proc "c" (poly: ^poly_t)

MixinKind :: enum
{
    World,
    Entity,
    Observable,
    Iterable,
    Dtor,
    Base,
    Max,
}

Header :: struct
{
    magic: c.int32_t,
    type: c.int32_t,
    mixins: ^Mixins,
}

Iterable :: struct
{
    init: iter_init_action_t,
}

InOutKind :: enum c.int
{
    InOutDefault,
    InOutNone,
    InOut,
    In,
    Out,
}

OperKind :: enum c.int
{
    And,
    Or,
    Not,
    Optional,
    AndFrom,
    OrFrom,
    NotFrom,
}

TermFlags :: enum u32
{
    Self = u32(1) << 1,
    Up = u32(1) << 2,
    Down = u32(1) << 3,
    Cascade = u32(1) << 4,
    Parent = u32(1) << 5,
    IsVariable = u32(1) << 6,
    IsEntity = u32(1) << 7,
    Filter = u32(1) << 8,

    TraverseFlags = (Up|Down|Self|Cascade|Parent),
}

TermId :: struct
{
    id: Entity,
    name: cstring,
    trav: Entity,
    flags: flags32_t,
}

// Term, Filter, Observer, TypeHooks, TypeInfo

Stage :: struct
{
    hdr: Header,

    // Unique id
    id: c.int32_t,

    // Deferred command queue
    _defer: c.int32_t,
    commands: Vec,
    defer_stack: Stack,
}

Record :: struct
{
    table: ^Table,
    row: c.uint32_t,
}

Data :: struct
{
    entities: Vec,
    records: Vec,
    columns: [^]Vec,
    sw_columns: [^]Switch,
    bs_columns: [^]Bitset,
}

// Sparse

Switch :: struct
{
    hdrs: Map,
    nodes: Vec,
    values: Vec,
}

IdRecord :: struct
{
    cache: TableCache,
    flags: flags32_t,
    refcount: c.int32_t,
    name_index: ^Hashmap,
    type_info: ^TypeInfo,
    id: id_t,
    parent: ^IdRecord,
    
    first: IdRecordElem,
    second: IdRecordElem,
    acyclic: IdRecordElem,
}

QueryTableNode :: struct
{
    next: ^QueryTableNode,
    prev: ^QueryTableNode,
    table: ^Table,
    group_id: c.uint64_t,
    offset: c.int32_t,
    count: c.int32_t,
    match: ^QueryTableMatch,
}

TableRecord :: struct
{
    hdr: TableCacheHdr,
    column: c.int32_t,
    count: c.int32_t,
}

// Allocator

// Observable, Record

TableRange :: struct
{
    table: ^Table,
    offset: c.int32_t,
    count: c.int32_t,
}

Var :: struct
{
    range: TableRange,
    entity: Entity,
}

// Ref

StackPage :: struct
{
    data: rawptr,
    next: ^StackPage,
    sp: c.int16_t,
    id: c.uint32_t,
}

StackCursor :: struct
{
    cur: ^StackPage,
    sp: c.int16_t,
}

PageIter :: struct
{
    offset: c.int32_t,
    limit: c.int32_t,
    remaining: c.int32_t,
}

WorkerIter :: struct
{
    index: c.int32_t,
    count: c.int32_t,
}

TableCacheIter :: struct
{
    cur: ^TableCacheHdr,
    next: ^TableCacheHdr,
    next_list: [^]TableCacheHdr,
}

TermIter :: struct
{
    term: Term,
    self_index: ^IdRecord,
    set_index: ^IdRecord,

    cur: ^IdRecord,
    it: TableCacheIter,
    index: c.int32_t,
    observed_table_count: c.int32_t,

    table: ^Table,
    cur_match: c.int32_t,
    match_count: c.int32_t,
    last_column: c.int32_t,

    empty_tables: bool,

    id: id_t,
    column: c.int32_t,
    subject: Entity,
    size: size_t,
    ptr: rawptr,
}

IterKind :: enum c.int
{
    Condition,
    Tables,
    Chain,
    None,
}

FilterIter :: struct
{
    filter: ^Filter,
    kind: IterKind,
    term_iter: TermIter,
    matches_left: c.int32_t,
    pivot_term: c.int32_t,
}

QueryIter :: struct
{
    query: ^Query,
    node: ^QueryTableNode,
    prev: ^QueryTableNode,
    last: ^QueryTableNode,
    sparse_smallest: c.int32_t,
    sparse_first: c.int32_t,
    bitset_first: c.int32_t,
    skip_count: c.int32_t,
}

SnapshotIter :: struct
{
    filter: Filter,
    tables: ^Vector,
    index: c.int32_t,
}

SparseIter :: struct
{
    sparse: ^Sparse,
    ids: [^]c.uint64_t,
    size: size_t,
    i: c.int32_t,
    count: c.int32_t,
}

RuleIter :: struct
{
    rule: ^Rule,
    registers: [^]Var,
    op_ctx: ^RuleOpCtx,
    columns: [^]c.int32_t,
    entity: Entity,
    redo: bool,
    op: c.int32_t,
    sp: c.int32_t,
}

iter_cache_ids :: u32(1) << u32(0)
iter_cache_columns :: u32(1) << u32(1)
iter_cache_sources :: u32(1) << u32(2)
iter_cache_sizes :: u32(1) << u32(3)
iter_cache_ptrs :: u32(1) << u32(4)
iter_cache_match_indices :: u32(1) << u32(5)
iter_cache_variables :: u32(1) << u32(6)
iter_cache_all :: 255

IterCache :: struct
{
    stack_cursor: StackCursor,
    used: flags8_t,
    allocated: flags8_t,
}

IterPrivate :: struct
{
    iter: struct #raw_union
    {
        term: TermIter,
        filter: FilterIter,
        query: QueryIter,
        rule: RuleIter,
        snapshot: SnapshotIter,
        page: PageIter,
        worker: WorkerIter,
    },
    cache: IterCache,
}

// Iter definition


IdRecordElem :: struct
{
    prev: ^IdRecord,
    next: ^IdRecord,
}