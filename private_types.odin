package flecs

import "core:c"

MAX_JOBS_PER_WORKER :: 16

OBJECT_MAGIC :: 0x6563736f

Mixin_Kind :: enum c.int
{
    World,
    Entity,
    Observable,
    Iterable,
    Dtor,
    Max,
}

// Mixins defined in flecs.odin

Hashed_String :: struct
{
    value: cstring,
    length: Size,
    hash: u64,
}

Table_EventKind :: enum c.int
{
    Triggers_For_Id,
    No_Triggers_For_Id,
}

Table_Event :: struct
{
    kind: Table_EventKind,
    query: ^Query,
    component: Entity,
    event: Entity,
}

// Data defined in flecs.odin

Table_Diff :: struct
{
    added: Type,
    removed: Type,
}

Table_Diff_Builder :: struct
{
    added: Vec,
    removed: Vec,
}

Graph_Edge_Hdr :: struct
{
    prev: ^Graph_Edge_Hdr,
    next: ^Graph_Edge_Hdr,
}

Graph_Edge :: struct
{
    hdr: Graph_Edge_Hdr,
    from: ^Table,
    to: ^Table,
    diff: ^Table_Diff,
    id: Id,
}

Graph_Edges :: struct
{
    lo: [^]Graph_Edge,
    hi: Map,
}

Graph_Node :: struct
{
    add: Graph_Edges,
    remove: Graph_Edges,
    refs: Graph_Edge_Hdr,
}

// TODO: These might need to be pointer arrays instead of pointers
Table_Ext :: struct
{
    sw_columns: ^Switch,
    bs_columns: ^BitSet,
    sw_count: i16,
    sw_offset: i16,
    bs_count: i16,
    bs_offset: i16,
    ft_offset: i16,
}

// Table defined in flecs.odin

Table_Cache_Hdr :: struct
{
    cache: ^Table_Cache,
    table: ^Table,
    prev: ^Table_Cache_Hdr,
    next: ^Table_Cache_Hdr,
    empty: c.bool,
}

Table_Cache_List :: struct
{
    first: ^Table_Cache_Hdr,
    last: ^Table_Cache_Hdr,
    count: i32,
}

Table_Cache :: struct
{
    index: Map,
    tables: Table_Cache_List,
    empty_tables: Table_Cache_List,
}

Switch_Term :: struct
{
    sw_column: ^Switch,
    sw_case: Entity,
    signature_column_index: i32,
}

BitSet_Term :: struct
{
    bs_column: ^BitSet,
    column_index: i32,
}

Flat_Monitor :: struct
{
    table_state: i32,
    monitor: i32,
}

Flat_Table_Term :: struct
{
    field_index: i32,
    term: ^Term,
    monitor: Vec,
}

Entity_Filter :: struct
{
    sw_terms: Vec,
    bs_terms: Vec,
    ft_terms: Vec,
    flat_tree_column: i32,
    has_filter: c.bool,
}

Entity_Filter_Iter :: struct
{
    entity_filter: ^Entity_Filter,
    it: ^Iter,
    columns: [^]i32,
    prev: ^Table,
    range: Table_Range,
    bs_offset: i32,
    sw_offset: i32,
    sw_smallest: i32,
    flat_tree_offset: i32,
    target_count: i32,
}

// Query_Table_Node defined in flecs.odin

Query_Table_Match :: struct
{
    node: Query_Table_Node,
    columns: [^]i32,
    storage_columns: [^]i32,
    ids: [^]Id,
    sources: [^]Entity,
    refs: Vec,
    entity_filter: Entity_Filter,
    next_match: ^Query_Table_Match,
    monitor: ^i32,
}

Query_Table :: struct
{
    hdr: Table_Cache_Hdr,
    first: ^Query_Table_Match,
    last: ^Query_Table_Match,
    table_id: u64,
    rematch_count: i32,
}

Query_Table_List :: struct
{
    first: ^Query_Table_Node,
    last: ^Query_Table_Node,
    info: Query_Group_Info,
}

Query_EventKind :: enum
{
    Table_Match,
    Table_Rematch,
    Table_Unmatch,
    Orphan,
}

Query_Event :: struct
{
    kind: Query_EventKind,
    table: ^Table,
    parent_query: ^Query,
}

Query_Allocators :: struct
{
    columns: Block_Allocator,
    ids: Block_Allocator,
    sources: Block_Allocator,
    monitors: Block_Allocator,
}

// Query defined in flecs.odin

Event_Id_Record :: struct
{
    self: Map,
    self_up: Map,
    up: Map,
    observers: Map,
    set_observers: Map,
    entity_observers: Map,
    observer_count: i32,
}

World_Allocators :: struct
{
    ptr: Map_Params,
    query_table_list: Map_Params,
    query_table: Block_Allocator,
    query_table_match: Block_Allocator,
    graph_edge_lo: Block_Allocator,
    graph_edge: Block_Allocator,
    id_record: Block_Allocator,
    id_record_chunk: Block_Allocator,
    table_diff: Block_Allocator,
    sparse_chunk: Block_Allocator,
    hashmap: Block_Allocator,
    diff_builder: Table_Diff_Builder,
}

Stage_Allocators :: struct
{
    iter_stack: Stack,
    deser_stack: Stack,
    cmd_entry_chunk: Block_Allocator,
}

Cmd_Kind :: enum
{
    Op_Clone,
    Op_Bulk_New,
    Op_Add,
    Op_Remove,
    Op_Set,
    Op_Emplace,
    Op_Mut,
    Op_Modified,
    Op_Add_Modified,
    Op_Path,
    Op_Delete,
    Op_Clear,
    Op_On_Delete_Action,
    Op_Enable,
    Op_Disable,
    Op_Skip,
}

Cmd_1 :: struct
{
    value: rawptr,
    size: Size,
    clone_value: c.bool,
}

Cmd_N :: struct
{
    entities: [^]Entity,
    count: i32,
}

Cmd :: struct
{
    kind: Cmd_Kind,
    next_for_entity: i32,
    id: Id,
    idr: ^Id_Record,
    entity: Entity,

    is: union {
        Cmd_1,
        Cmd_N,
    },
}

Cmd_Entry :: struct
{
    first: i32,
    last: i32,
}

// Stage defined in flecs.odin

Monitor :: struct
{
    queries: Vec,
    is_dirty: c.bool,
}

Monitor_Set :: struct
{
    monitors: Map,
    is_dirty: c.bool,
}

Marked_Id :: struct
{
    idr: ^Id_Record,
    id: Id,
    action: Entity,
    delete_id: c.bool,
}

Store :: struct
{
    entity_index: Sparse,
    tables: Sparse,
    table_map: HashMap,
    root: Table,
    records: Vec,
    marked_ids: Vec,
    depth_ids: Vec,
    entity_to_depth: Map,
}

Action_Elem :: struct
{
    action: Fini_Action,
    ctx: rawptr,
}

// World defined in flecs.odin