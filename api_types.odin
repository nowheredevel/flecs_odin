package flecs

import "core:c"

/// Flecs' opaque types (Not opaque in Odin)
// TODO: Move opaque type defs to proper files (Except for those originally defined in private_types.h)
// Defined in private_types.h, definition contained here
Stage :: struct
{
    hdr: Header,

    id: i32,

    /// Deferred command queue
    defer_: i32,
    commands: Vec,
    defer_stack: Stack,
    cmd_entries: Sparse,

    /// Thread context
    thread_ctx: ^World,
    world: ^World,
    thread: OS_Thread,

    /// One-shot actions
    post_frame_actions: Vec,

    /// Namespacing
    scope: Entity,
    with: Entity,
    base: Entity,
    lookup_path: ^Entity,

    /// Properties
    auto_merge: c.bool,
    async: c.bool,

    /// Thread specific allocators
    allocators: Stage_Allocators,
    allocator: Allocator,

    /// Caches for rule creation
    variables: Vec,
    operations: Vec,
}

Record :: struct
{
    idr: ^Id_Record,
    table: ^Table,
    row: u32,
}

Data :: struct
{
    entities: Vec,
    records: Vec,
    columns: ^Vec,
}

// Switch defined in switch_list.odin

Query_Table_Node :: struct
{
    next: ^Query_Table_Node,
    prev: ^Query_Table_Node,
    table: ^Table,
    group_id: u64,
    offset: i32,
    count: i32,
    match: ^Query_Table_Match,
}

/// Flecs' non-opaque types

Event_Record :: struct
{
    any_: ^Event_Id_Record,
    wildcard: ^Event_Id_Record,
    wildcard_pair: ^Event_Id_Record,
    event_ids: Map,
    event: Entity,
}

Observable :: struct
{
    on_add: Event_Record,
    on_remove: Event_Record,
    on_set: Event_Record,
    un_set: Event_Record,
    on_wildcard: Event_Record,
    events: Sparse,
}

// Record already defined

Table_Range :: struct
{
    table: ^Table,
    offset: i32,
    count: i32,
}

Var :: struct
{
    range: Table_Range,
    entity: Entity,
}

Ref :: struct
{
    entity: Entity,
    id: Entity,
    tr: ^Table_Record,
    record: ^Record,
}

Stack_Page :: struct
{
    data: rawptr,
    next: ^Stack_Page,
    sp: i16,
    id: u32,
}

Stack_Cursor :: struct
{
    cur: ^Stack_Page,
    sp: i16,
}

Page_Iter :: struct
{
    offset: i32,
    limit: i32,
    remaining: i32,
}

Worker_Iter :: struct
{
    index: i32,
    count: i32,
}

Table_Cache_Iter :: struct
{
    cur: ^Table_Cache_Hdr,
    next: ^Table_Cache_Hdr,
    next_list: [^]Table_Cache_Hdr,
}

Term_Iter :: struct
{
    term: Term,
    self_index: ^Id_Record,
    set_index: ^Id_Record,

    cur: ^Id_Record,
    it: Table_Cache_Iter,
    index: i32,
    observed_table_count: i32,

    table: ^Table,
    cur_match: i32,
    match_count: i32,
    last_column: i32,

    empty_tables: c.bool,

    /// Storage
    id: Id,
    column: i32,
    subject: Entity,
    size: Size,
    ptr: rawptr,
}

Iter_Kind :: enum
{
    Eval_Condition,
    Eval_Tables,
    Eval_Chain,
    Eval_None,
}

Filter_Iter :: struct
{
    filter: ^Filter,
    kind: Iter_Kind,
    term_iter: Term_Iter,
    matches_left: i32,
    pivot_term: i32,
}

Query_Iter :: struct
{
    query: ^Query,
    node: ^Query_Table_Node,
    prev: ^Query_Table_Node,
    last: ^Query_Table_Node,
    sparse_smallest: i32,
    sparse_first: i32,
    bitset_first: i32,
    skip_count: i32,
}

Snapshot_Iter :: struct
{
    filter: Filter,
    tables: Vec,
    index: i32,
}

Rule_Op_Profile :: struct
{
    count: [2]i32,
}

Rule_Iter :: struct
{
    rule: ^Rule,
    vars: [^]Var,
    rule_vars: [^]Rule_Var,
    ops: [^]Rule_Op,
    op_ctx: ^Rule_Op_Ctx,
    written: ^u64,
    
    // There's usually a debug-only member here, but ideally the end developer should be using release builds of flecs anyway

    redo: c.bool,
    op: i16,
    sp: i16,
}

Iter_Cache_Bits :: enum u32
{
    Ids = 1 << 0,
    Columns = 1 << 1,
    Sources = 1 << 2,
    Ptrs = 1 << 3,
    Match_Indices = 1 << 4,
    Variables = 1 << 5,
    All = 255,
}

Iter_Cache :: struct
{
    stack_cursor: Stack_Cursor,
    used: Flags8,
    allocated: Flags8,
}

Iter_Private :: struct
{
    iter: struct #raw_union {
        term: Term_Iter,
        filter: Filter_Iter,
        query: Query_Iter,
        rule: Rule_Iter,
        snapshot: Snapshot_Iter,
        page: Page_Iter,
        worker: Worker_Iter,
    },

    entity_iter: rawptr,
    cache: Iter_Cache,
}

Iter :: struct
{
    /// World
    world: ^World,
    real_world: ^World,

    /// Matched data
    entities: [^]Entity,
    ptrs: [^]rawptr,
    sizes: [^]Size,
    table: ^Table,
    other_table: ^Table,
    ids: [^]Id,
    variables: [^]Var,
    columns: [^]i32,
    sources: [^]Entity,
    match_indices: [^]i32,
    references: [^]Ref,
    constrained_vars: Flags64,
    group_id: u64,
    field_count: i32,

    /// Input information
    system: Entity,
    event: Entity,
    event_id: Id,

    /// Query information
    terms: [^]Term,
    table_count: i32,
    term_index: i32,
    variable_count: i32,
    variable_names: [^]cstring,

    /// Context
    param: rawptr,
    ctx: rawptr,
    binding_ctx: rawptr,

    /// Time
    delta_time: FTime,
    delta_system_time: FTime,

    /// Iterator counters
    frame_offset: i32,
    offset: i32,
    count: i32,
    instance_count: i32,

    /// Iterator flags
    flags: Flags32,

    interrupted_by: Entity,
    
    priv: Iter_Private,

    /// Chained iterators
    next: Iter_Next_Action,
    callback: Iter_Action,
    fini: Iter_Fini_Action,
    chain_it: ^Iter,
}