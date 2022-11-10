package flecs

import "core:c"

// Private types defined in flecs.c

TableCacheHdr :: struct
{
    cache: ^TableCache,
    table: ^Table,
    prev: ^TableCacheHdr,
    next: ^TableCacheHdr,
    empty: bool,
}

TableCacheList :: struct
{
    first: ^TableCacheHdr,
    last: ^TableCacheHdr,
    count: c.int32_t,
}

TableCache :: struct
{
    index: Map,
    tables: TableCacheList,
    empty_tables: TableCacheList,
}

TableEventKind :: enum c.int
{
    TriggersForId,
    NoTriggersForId,
}

TableEvent :: struct
{
    kind: TableEventKind,
    query: ^Query,
    component: Entity,
    event: Entity,
}

TableDiff :: struct
{
    added: Type,
    removed: Type,
    on_set: Type,
    un_set: Type,
}

TableDiffBuilder :: struct
{
    added: Vec,
    removed: Vec,
    on_set: Vec,
    un_set: Vec,
}

GraphEdgeHdr :: struct
{
    prev: ^GraphEdgeHdr,
    nex: ^GraphEdgeHdr,
}

GraphEdge :: struct
{
    hdr: GraphEdgeHdr,
    from: ^Table,
    to: ^Table,
    diff: ^TableDiff,
    id: id_t,
}

GraphEdges :: struct
{
    lo: [^]GraphEdge,
    hi: Map,
}

GraphNode :: struct
{
    add: GraphEdges,
    remove: GraphEdges,
    refs: GraphEdgeHdr,
}

QueryTableMatch :: struct
{
    node: QueryTableNode,
    columns: [^]c.int32_t,
    storage_columns: [^]c.int32_t,
    ids: [^]id_t,
    sources: [^]Entity,
    sizes: [^]size_t,
    refs: Vec,
    sparse_columns: [^]Vector,
    bitset_columns: [^]Vector,

    next_match: ^QueryTableMatch,
    monitor: ^c.int32_t,
}

QueryTable :: struct
{
    hdr: TableCacheHdr,
    first: ^QueryTableMatch,
    last: ^QueryTableMatch,
    rematch_count: c.int32_t,
}

QueryTableList :: struct
{
    first: ^QueryTableNode,
    last: ^QueryTableNode,
    info: QueryGroupInfo,
}

QueryEventKind :: enum c.int
{
    TableMatch,
    TableRematch,
    TableUnmatch,
    Orphan,
}

QueryEvent :: struct
{
    kind: QueryEventKind,
    table: ^Table,
    parent_query: ^Query,
}

QueryAllocators :: struct
{
    columns: BlockAllocator,
    ids: BlockAllocator,
    sources: BlockAllocator,
    sizes: BlockAllocator,
    monitors: BlockAllocator,
}

// RULES
RULE_MAX_VAR_COUNT :: 32
RULE_PAIR_PREDICATE :: 1
RULE_PAIR_OBJECT :: 2

RulePair :: struct
{
    first: struct #raw_union
    {
        reg: c.int32_t,
        id: Entity,
    },

    second: struct #raw_union
    {
        reg: c.int32_t,
        id: Entity,
    },

    reg_mask: c.int32_t,
    transitive: bool,
    final: bool,
    reflexive: bool,
    acyclic: bool,
    second_0: bool,
}

RuleFilter :: struct
{
    mask: id_t,

    wildcard: bool,
    first_wildcard: bool,
    second_wildcard: bool,
    same_var: bool,

    hi_var: c.int32_t,
    lo_var: c.int32_t,
}

RuleVarKind :: enum c.int
{
    Table,
    Entity,
    Unknown,
}

RuleOpKind :: enum c.int
{
    Input,
    Select,
    With,
    SubSet,
    SuperSet,
    Store,
    Each,
    SetJmp,
    Jump,
    Not,
    InTable,
    Eq,
    Yield,
}

RuleOp :: struct
{
    kind: RuleOpKind,
    filter: RulePair,
    subject: Entity,

    on_pass: c.int32_t,
    on_fail: c.int32_t,
    frame: c.int32_t,
    term: c.int32_t,
    r_in: c.int32_t,
    r_out: c.int32_t,
    has_in: bool,
    has_out: bool,
}

RuleWithCtx :: struct
{
    idr: ^IdRecord,
    it: TableCacheIter,
    column: c.int32_t,
}

RuleSubSetFrame :: struct
{
    with_ctx: RuleWithCtx,
    table: ^Table,
    row: c.int32_t,
    column: c.int32_t,
}

RuleSubSetCtx :: struct
{
    storage: [16]RuleSubSetFrame,
    stack: [^]RuleSubSetFrame,
    sp: c.int32_t,
}

RuleSuperSetFrame :: struct
{
    table: ^Table,
    column: c.int32_t,
}

RuleSuperSetCtx :: struct
{
    storage: [16]RuleSuperSetFrame,
    stack: [^]RuleSuperSetFrame,
    idr: ^IdRecord,
    sp: c.int32_t,
}

RuleEachCtx :: struct
{
    row: c.int32_t,
}

RuleSetJmpCtx :: struct
{
    label: c.int32_t,
}

RuleOpCtx :: struct
{
    is: struct #raw_union
    {
        subset: RuleSubSetCtx,
        superset: RuleSuperSetCtx,
        with: RuleWithCtx,
        each: RuleEachCtx,
        setjmp: RuleSetJmpCtx,
    },
}

RuleVar :: struct
{
    kind: RuleVarKind,
    name: cstring,
    id: c.int32_t,
    other: c.int32_t,
    occurs: c.int32_t,
    depth: c.int32_t,
    marked: bool,
}

RuleTermVars :: struct
{
    first: c.int32_t,
    src: c.int32_t,
    second: c.int32_t,
}

Monitor :: struct
{
    queries: ^Vector,
    is_dirty: bool,
}

MonitorSet :: struct
{
    monitors: Map,
    is_dirty: bool,
}

MarkedId :: struct
{
    idr: ^IdRecord,
    id: id_t,
    action: Entity,
}

Store :: struct
{
    entity_index: Sparse,
    tables: Sparse,
    table_map: Hashmap,
    root: Table,
    records: ^Vector,
    marked_ids: ^Vector,
}

WorldAllocators :: struct
{
    ptr: MapParams,
    query_table_list: MapParams,
    query_table: BlockAllocator,
    query_table_match: BlockAllocator,
    graph_edge_lo: BlockAllocator,
    graph_edge: BlockAllocator,
    id_record: BlockAllocator,
    table_diff: BlockAllocator,
    sparse_chunk: BlockAllocator,
    hashmap: BlockAllocator,

    diff_builder: TableDiffBuilder,
}

EventDesc :: struct
{
    event: Entity,
    ids: [^]Type,
    table: ^Table,
    other_table: ^Table,
    offset: c.int32_t,
    count: c.int32_t,
    param: rawptr,
    observable: ^poly_t,
    table_event: c.bool,
    relationship: Entity,
}