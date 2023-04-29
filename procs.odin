package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "system:flecs.lib"
}

// _ Functions
@(default_calling_convention = "c", link_prefix = "_ecs", private)
foreign flecs
{
    // Map
    _map_get_deref :: proc(map_: ^Map, key: Map_Key) -> rawptr ---

    // Misc
    _poly_is :: proc(object: Poly, type_: i32) -> c.bool ---
}

// Public functions
@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // OS API
    os_init :: proc() ---
    os_fini :: proc() ---
    os_set_api :: proc(os_api: ^OS_API) ---
    os_get_api :: proc() -> OS_API ---
    os_set_api_defaults :: proc() ---

    // API Support
    module_path_from_c :: proc(c_name: cstring) -> cstring ---
    default_ctor :: proc(ptr: rawptr, count: i32, ctx: ^Type_Info) ---
    asprintf :: proc(fmt: cstring, #c_vararg args: ..any) -> cstring ---

    // Map
    map_params_init :: proc(params: ^Map_Params, allocator: ^Allocator) ---
    map_params_fini :: proc(params: ^Map_Params) ---
    map_init :: proc(map_: ^Map, allocator: ^Allocator) ---
    map_init_w_params :: proc(map_: ^Map, params: ^Map_Params) ---
    map_init_if :: proc(map_: ^Map, allocator: ^Allocator) ---
    map_init_w_params_if :: proc(result: ^Map, params: ^Map_Params) ---
    map_fini :: proc(map_: ^Map) ---
    map_get :: proc(map_: ^Map, key: Map_Key) -> ^Map_Val ---
    map_ensure :: proc(map_: ^Map, key: Map_Key) -> ^Map_Val ---
    map_ensure_alloc :: proc(map_: ^Map, elem_size: Size, key: Map_Key) -> rawptr ---
    map_insert :: proc(map_: ^Map, key: Map_Key, value: Map_Val) ---
    map_insert_alloc :: proc(map_: ^Map, elem_size: Size, key: Map_Key) -> rawptr ---
    map_remove :: proc(map_: ^Map, key: Map_Key) -> Map_Val ---
    map_remove_free :: proc(map_: ^Map, key: Map_Key) ---
    map_clear :: proc(map_: ^Map) ---
    map_iter :: proc(map_: ^Map) -> Map_Iter ---
    map_next :: proc(iter: ^Map_Iter) -> c.bool ---
    map_copy :: proc(dst: ^Map, src: ^Map) ---

    // Sparse
    sparse_init :: proc(sparse: ^Sparse, elem_size: Size) ---
    sparse_add :: proc(sparse: ^Sparse, elem_size: Size) -> rawptr ---
    sparse_last_id :: proc(sparse: ^Sparse) -> u64 ---
    sparse_count :: proc(sparse: ^Sparse) -> i32 ---
    sparse_get_dense :: proc(sparse: ^Sparse, elem_size: Size, index: i32) -> rawptr ---
    sparse_get :: proc(sparse: ^Sparse, elem_size: Size, id: u64) -> rawptr ---

    // StrBuf
    strbuf_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) -> c.bool ---
    strbuf_vappend :: proc(buffer: ^StrBuf, fmt: cstring, args: cstring) -> c.bool ---
    strbuf_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> c.bool ---
    strbuf_appendint :: proc(buffer: ^StrBuf, v: i64) -> c.bool ---
    strbuf_appendflt :: proc(buffer: ^StrBuf, v: c.double, nan_delim: c.char) -> c.bool ---
    strbuf_mergebuff :: proc(dst_buffer: ^StrBuf, src_buffer: ^StrBuf) -> c.bool ---
    strbuf_appendstr_zerocpy :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendstr_zerocpyn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_appendstr_zerocpy_const :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendstr_zerocpyn_const :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_get :: proc(buffer: ^StrBuf) -> cstring ---
    strbuf_get_small :: proc(buffer: ^StrBuf) -> cstring ---
    strbuf_reset :: proc(buffer: ^StrBuf) ---
    strbuf_list_push :: proc(buffer: ^StrBuf, list_open: cstring, separator: cstring) ---
    strbuf_list_pop :: proc(buffer: ^StrBuf, list_close: cstring) ---
    strbuf_list_next :: proc(buffer: ^StrBuf) ---
    strbuf_list_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> c.bool ---
    strbuf_list_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) -> c.bool ---
    strbuf_list_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_list_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_written :: proc(buffer: ^StrBuf) -> i32 ---

    // Vec
    vec_init :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) -> ^Vec ---
    vec_init_if :: proc(vec: ^Vec, size: Size) ---
    vec_fini :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) ---
    vec_reset :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> ^Vec ---
    vec_clear :: proc(vec: ^Vec) ---
    vec_append :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> rawptr ---
    vec_remove :: proc(vec: ^Vec, size: Size, elem: i32) ---
    vec_remove_last :: proc(vec: ^Vec) ---
    vec_copy :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> Vec ---
    vec_reclaim :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) ---
    vec_set_size :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_size :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_count :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_count_zeromem :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_count :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_grow :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) -> rawptr ---
    vec_count :: proc(vec: ^Vec) -> i32 ---
    vec_size :: proc(vec: ^Vec) -> i32 ---
    vec_get :: proc(vec: ^Vec, size: Size, index: i32) -> rawptr ---
    vec_first :: proc(vec: ^Vec) -> rawptr ---
    vec_last :: proc(vec: ^Vec, size: Size) -> rawptr ---

    // World
    init :: proc() -> ^World ---
    mini :: proc() -> ^World ---
    init_w_args :: proc(argc: c.int, argv: []cstring) -> ^World ---
    fini :: proc(world: ^World) -> c.int ---
    is_fini :: proc(world: ^World) -> c.bool ---
    atfini :: proc(world: ^World, action: Fini_Action, ctx: rawptr) ---

    // Frame functions
    frame_begin :: proc(world: ^World, delta_time: FTime) -> FTime ---
    frame_end :: proc(world: ^World) ---
    run_post_frame :: proc(world: ^World, action: Fini_Action, ctx: rawptr) ---
    quit :: proc(world: ^World) ---
    should_quit :: proc(world: ^World) -> c.bool ---
    measure_frame_time :: proc(world: ^World, enable: c.bool) ---
    measure_system_time :: proc(world: ^World, enable: c.bool) ---
    set_target_fps :: proc(world: ^World, fps: FTime) ---

    // Commands
    readonly_begin :: proc(world: ^World) -> c.bool ---
    readonly_end :: proc(world: ^World) ---
    merge :: proc(world: ^World) ---
    defer_begin :: proc(world: ^World) -> c.bool ---
    is_deferred :: proc(world: ^World) -> c.bool ---
    defer_end :: proc(world: ^World) -> c.bool ---
    defer_suspend :: proc(world: ^World) ---
    defer_resume :: proc(world: ^World) ---
    set_automerge :: proc(world: ^World, automerge: c.bool) ---
    set_stage_count :: proc(world: ^World, stages: i32) ---
    get_stage_count :: proc(world: ^World) -> i32 ---
    get_stage_id :: proc(world: ^World) -> i32 ---
    get_stage :: proc(world: ^World, stage_id: i32) -> ^World ---
    stage_is_readonly :: proc(world: ^World) -> c.bool ---
    async_stage_new :: proc(world: ^World) -> ^World ---
    async_stage_free :: proc(stage: ^World) ---
    stage_is_async :: proc(stage: ^World) -> c.bool ---

    // Misc
    set_context :: proc(world: ^World, ctx: rawptr) ---
    get_context :: proc(world: ^World) -> rawptr ---
    get_world_info :: proc(world: ^World) -> ^World_Info ---
    dim :: proc(world: ^World, entity_count: i32) ---
    set_entity_range :: proc(world: ^World, id_start: Entity, id_end: Entity) ---
    enable_range_check :: proc(world: ^World, enable: c.bool) -> c.bool ---
    run_aperiodic :: proc(world: ^World, flags: Flags32) ---
    delete_empty_tables :: proc(
        world: ^World,
        id: Id,
        clear_generation: u16,
        delete_generation: u16,
        min_id_count: i32,
        time_budget_seconds: f64,
    ) -> i32 ---
    get_world :: proc(poly: Poly) -> ^World ---
    get_entity :: proc(poly: Poly) -> Entity ---
    make_pair :: proc(first: Entity, second: Entity) -> Entity ---

    // Entities
    
    // Creating & Deleting
    new_id :: proc(world: ^World) -> Entity ---
    new_low_id :: proc(world: ^World) -> Entity ---
    new_w_id :: proc(world: ^World, id: Id) -> Entity ---
    new_w_table :: proc(world: ^World, table: ^Table) -> Entity ---
    entity_init :: proc(world: ^World, desc: ^Entity_Desc) -> Entity ---
    bulk_init :: proc(world: ^World, desc: ^Bulk_Desc) -> [^]Entity ---
    bulk_new_w_id :: proc(world: ^World, id: Id, count: i32) -> [^]Entity ---
    clone :: proc(
        world: ^World,
        dst: Entity,
        src: Entity,
        copy_value: c.bool,
    ) -> Entity ---
    delete :: proc(world: ^World, entity: Entity) ---
    delete_with :: proc(world: ^World, id: Id) ---

    // Adding & Removing
    add_id :: proc(world: ^World, entity: Entity, id: Id) ---
    remove_id :: proc(world: ^World, entity: Entity, id: Id) ---
    override_id :: proc(world: ^World, entity: Entity, id: Id) ---
    clear :: proc(world: ^World, entity: Entity) ---
    remove_all :: proc(world: ^World, id: Id) ---
    set_with :: proc(world: ^World, id: Id) -> Entity ---
    get_with :: proc(world: ^World) -> Id ---

    // Enable & Disabling
    enable :: proc(world: ^World, entity: Entity, enabled: c.bool) ---
    enable_id :: proc(world: ^World, entity: Entity, id: Id, enable: c.bool) ---
    is_enabled_id :: proc(world: ^World, entity: Entity, id: Id) -> c.bool ---

    // Getting & Setting
    get_id :: proc(world: ^World, entity: Entity, id: Id) -> rawptr ---
    ref_init_id :: proc(world: ^World, entity: Entity, id: Id) -> Ref ---
    ref_get_id :: proc(world: ^World, ref: ^Ref, id: Id) -> rawptr ---
    ref_update :: proc(world: ^World, ref: ^Ref) ---
    get_mut_id :: proc(world: ^World, entity: Entity, id: Id) -> rawptr ---
    write_begin :: proc(world: ^World, entity: Entity) -> ^Record ---
    write_end :: proc(record: ^Record) ---
    read_begin :: proc(world: ^World, entity: Entity) -> ^Record ---
    read_end :: proc(record: ^Record) ---
    record_get_entity :: proc(record: ^Record) -> Entity ---
    record_get_id :: proc(world: ^World, record: ^Record, id: Id) -> rawptr ---
    record_get_mut_id :: proc(world: ^World, record: ^Record, id: Id) -> rawptr ---
    record_has_id :: proc(world: ^World, record: ^Record, id: Id) -> c.bool ---
    emplace_id :: proc(world: ^World, entity: Entity, id: Id) -> rawptr ---
    modified_id :: proc(world: ^World, entity: Entity, id: Id) ---
    set_id :: proc(
        world: ^World,
        entity: Entity,
        id: Id,
        size: Size,
        ptr: rawptr,
    ) -> Entity ---

    // Entity Liveliness
    is_valid :: proc(world: ^World, e: Entity) -> c.bool ---
    is_alive :: proc(world: ^World, e: Entity) -> c.bool ---
    strip_generation :: proc(e: Entity) -> Id ---
    set_entity_generation :: proc(world: ^World, entity: Entity) ---
    get_alive :: proc(world: ^World, e: Entity) -> Entity ---
    ensure :: proc(world: ^World, entity: Entity) ---
    ensure_id :: proc(world: ^World, id: Id) ---
    exists :: proc(world: ^World, entity: Entity) -> c.bool ---

    // Entity Information
    get_type :: proc(world: ^World, entity: Entity) -> ^Type ---
    get_table :: proc(world: ^World, entity: Entity) -> ^Table ---
    type_str :: proc(world: ^World, type_: ^Type) -> cstring ---
    table_str :: proc(world: ^World, table: ^Table) -> cstring ---
    entity_str :: proc(world: ^World, entity: Entity) -> cstring ---
    has_id :: proc(world: ^World, entity: Entity, id: Id) -> c.bool ---
    get_target :: proc(
        world: ^World, 
        entity: Entity, 
        rel: Entity, 
        index: i32,
    ) -> Entity ---
    get_parent :: proc(world: ^World, entity: Entity) -> Entity ---
    get_target_for_id :: proc(
        world: ^World,
        entity: Entity,
        rel: Entity,
        id: Id,
    ) -> Entity ---
    get_depth :: proc(
        world: ^World,
        entity: Entity,
        rel: Entity,
    ) -> i32 ---
    flatten :: proc(
        world: ^World,
        pair: Id,
        desc: ^Flatten_Desc,
    ) ---
    count_id :: proc(world: ^World, entity: Id) -> i32 ---

    // Entity Names
    get_name :: proc(world: ^World, entity: Entity) -> cstring ---
    get_symbol :: proc(world: ^World, entity: Entity) -> cstring ---
    set_name :: proc(world: ^World, entity: Entity, name: cstring) -> Entity ---
    set_symbol :: proc(world: ^World, entity: Entity, symbol: cstring) -> Entity ---
    set_alias :: proc(world: ^World, entity: Entity, alias: cstring) ---
    lookup :: proc(world: ^World, name: cstring) -> Entity ---
    lookup_child :: proc(world: ^World, parent: Entity, name: cstring) -> Entity ---
    lookup_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
        recursive: c.bool,
    ) -> Entity ---
    lookup_symbol :: proc(
        world: ^World,
        symbol: cstring,
        lookup_as_path: c.bool,
    ) -> Entity ---
    get_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        child: Entity,
        sep: cstring,
        prefix: cstring,
    ) -> cstring ---
    get_path_w_sep_buf :: proc(
        world: ^World,
        parent: Entity,
        child: Entity,
        sep: cstring,
        prefix: cstring,
        buf: ^StrBuf,
    ) ---
    new_from_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
    ) -> Entity ---
    add_path_w_sep :: proc(
        world: ^World,
        entity: Entity,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
    ) -> Entity ---
    set_scope :: proc(world: ^World, scope: Entity) -> Entity ---
    get_scope :: proc(world: ^World) -> Entity ---
    set_name_prefix :: proc(world: ^World, prefix: cstring) -> cstring ---
    set_lookup_path :: proc(
        world: ^World,
        lookup_path: [^]Entity,
    ) -> [^]Entity ---
    get_lookup_path :: proc(world: ^World) -> [^]Entity ---

    // Components
    component_init :: proc(world: ^World, desc: ^Component_Desc) -> Entity ---
    set_hooks_id :: proc(world: ^World, id: Entity, hooks: ^Type_Hooks) ---
    get_hooks_id :: proc(world: ^World, id: Entity) -> ^Type_Hooks ---

    // Ids
    id_is_tag :: proc(world: ^World, id: Id) -> c.bool ---
    id_is_union :: proc(world: ^World, id: Id) -> c.bool ---
    id_in_use :: proc(world: ^World, id: Id) -> c.bool ---
    get_type_info :: proc(world: ^World, id: Id) -> ^Type_Info ---
    get_typeid :: proc(world: ^World, id: Id) -> Entity ---
    id_match :: proc(id: Id, pattern: Id) -> c.bool ---
    id_is_pair :: proc(id: Id) -> c.bool ---
    id_is_wildcard :: proc(id: Id) -> c.bool ---
    id_is_valid :: proc(world: ^World, id: Id) -> c.bool ---
    id_get_flags :: proc(world: ^World, id: Id) -> Flags32 ---
    id_flag_str :: proc(id_flags: Id) -> cstring ---
    id_str :: proc(world: ^World, id: Id) -> cstring ---
    id_str_buf :: proc(world: ^World, id: Id, buf: ^StrBuf) ---

    // Filters
    term_iter :: proc(world: ^World, term: ^Term) -> Iter ---
    term_chain_iter :: proc(it: ^Iter, term: ^Term) -> Iter ---
    term_next :: proc(it: ^Iter) -> c.bool ---
    children :: proc(world: ^World, parent: Entity) -> Iter ---
    children_next :: proc(it: ^Iter) -> c.bool ---
    term_id_is_set :: proc(id: ^Term_Id) -> c.bool ---
    term_is_initialized :: proc(term: ^Term) -> c.bool ---
    term_match_this :: proc(term: ^Term) -> c.bool ---
    term_match_0 :: proc(term: ^Term) -> c.bool ---
    term_finalize :: proc(world: ^World, term: ^Term) -> c.int ---
    term_copy :: proc(src: ^Term) -> Term ---
    term_move :: proc(src: ^Term) -> Term ---
    term_fini :: proc(term: ^Term) ---
    filter_init :: proc(world: ^World, desc: ^Filter_Desc) -> ^Filter ---
    filter_fini :: proc(filter: ^Filter) ---
    filter_finalize :: proc(world: ^World, filter: ^Filter) -> c.int ---
    filter_find_this_var :: proc(filter: ^Filter) -> i32 ---
    term_str :: proc(world: ^World, term: ^Term) -> cstring ---
    filter_str :: proc(world: ^World, filter: ^Filter) -> cstring ---
    filter_iter :: proc(world: ^World, filter: ^Filter) -> Iter ---
    filter_chain_iter :: proc(it: ^Iter, filter: ^Filter) -> Iter ---
    filter_pivot_term :: proc(world: ^World, filter: ^Filter) -> i32 ---
    filter_next :: proc(it: ^Iter) -> c.bool ---
    filter_next_instanced :: proc(it: ^Iter) -> c.bool ---
    filter_move :: proc(dst: ^Filter, src: ^Filter) ---
    filter_copy :: proc(dst: ^Filter, src: ^Filter) ---

    // Queries
    query_init :: proc(world: ^World, desc: ^Query_Desc) -> ^Query ---
    query_fini :: proc(query: ^Query) ---
    query_get_filter :: proc(query: ^Query) -> ^Filter ---
    query_iter :: proc(world: ^World, query: ^Query) -> Iter ---
    query_next :: proc(iter: ^Iter) -> c.bool ---
    query_next_instanced :: proc(iter: ^Iter) -> c.bool ---
    query_next_table :: proc(iter: ^Iter) -> c.bool ---
    query_populate :: proc(iter: ^Iter, when_changed: c.bool) -> c.int ---
    query_changed :: proc(query: ^Query, it: ^Iter) -> c.bool ---
    query_skip :: proc(it: ^Iter) ---
    query_set_group :: proc(it: ^Iter, group_id: u64) ---
    query_get_group_ctx :: proc(query: ^Query, group_id: u64) -> rawptr ---
    query_get_group_info :: proc(query: ^Query, group_id: u64) -> ^Query_Group_Info ---
    query_orphaned :: proc(query: ^Query) -> c.bool ---
    query_str :: proc(query: ^Query) -> cstring ---
    query_table_count :: proc(query: ^Query) -> i32 ---
    query_empty_table_count :: proc(query: ^Query) -> i32 ---
    query_entity_count :: proc(query: ^Query) -> i32 ---

    // Observers
    emit :: proc(world: ^World, desc: ^Event_Desc) ---
    observer_init :: proc(world: ^World, desc: ^Observer_Desc) -> Entity ---
    observer_default_run_action :: proc(it: ^Iter) -> c.bool ---
    get_observer_ctx :: proc(world: ^World, observer: Entity) -> rawptr ---
    get_observer_binding_ctx :: proc(world: ^World, observer: Entity) -> rawptr ---

    // Iterators
    iter_poly :: proc(world: ^World, poly: Poly, iter: ^Iter, filter: ^Filter) ---
    iter_next :: proc(it: ^Iter) -> c.bool ---
    iter_fini :: proc(it: ^Iter) ---
    iter_count :: proc(it: ^Iter) -> i32 ---
    iter_is_true :: proc(it: ^Iter) -> c.bool ---
    iter_first :: proc(it: ^Iter) -> Entity ---
    iter_set_var :: proc(it: ^Iter, var_id: i32, entity: Entity) ---
    iter_set_var_as_table :: proc(it: ^Iter, var_id: i32, table: ^Table) ---
    iter_set_var_as_range :: proc(it: ^Iter, var_id: i32, range: ^Table_Range) ---
    iter_get_var :: proc(it: ^Iter, var_id: i32) -> Entity ---
    iter_get_var_as_table :: proc(it: ^Iter, var_id: i32) -> ^Table ---
    iter_get_var_as_range :: proc(it: ^Iter, var_id: i32) -> Table_Range ---
    iter_var_is_constrained :: proc(it: ^Iter, var_id: i32) -> c.bool ---
    page_iter :: proc(it: ^Iter, offset: i32, limit: i32) -> Iter ---
    page_next :: proc(it: ^Iter) -> c.bool ---
    worker_iter :: proc(it: ^Iter, index: i32, count: i32) -> Iter ---
    worker_next :: proc(it: ^Iter) -> c.bool ---
    field_w_size :: proc(it: ^Iter, size: Size, index: i32) -> rawptr ---
    field_is_readonly :: proc(it: ^Iter, index: i32) -> c.bool ---
    field_is_writeonly :: proc(it: ^Iter, index: i32) -> c.bool ---
    field_is_set :: proc(it: ^Iter, index: i32) -> c.bool ---
    field_id :: proc(it: ^Iter, index: i32) -> Id ---
    field_column_index :: proc(it: ^Iter, index: i32) -> i32 ---
    field_src :: proc(it: ^Iter, index: i32) -> Entity ---
    field_size :: proc(it: ^Iter, index: i32) -> Size ---
    field_is_self :: proc(it: ^Iter, index: i32) -> c.bool ---
    iter_str :: proc(it: ^Iter) -> cstring ---

    // Tables
    table_get_type :: proc(table: ^Table) -> ^Type ---
    table_get_column :: proc(table: ^Table, index: i32, offset: i32) -> rawptr ---
    table_get_column_size :: proc(table: ^Table, index: i32) -> Size ---
    table_get_index :: proc(world: ^World, table: ^Table, id: Id) -> i32 ---
    table_has_id :: proc(world: ^World, table: ^Table, id: Id) -> c.bool ---
    table_get_id :: proc(world: ^World, table: ^Table, id: Id, offset: i32) -> rawptr ---
    table_get_depth :: proc(world: ^World, table: ^Table, rel: Entity) -> i32 ---
    table_get_storage_table :: proc(table: ^Table) -> ^Table ---
    table_type_to_storage_index :: proc(table: ^Table, index: i32) -> i32 ---
    table_storage_to_type_index :: proc(table: ^Table, index: i32) -> i32 ---
    table_count :: proc(table: ^Table) -> i32 ---
    table_add_id :: proc(world: ^World, table: ^Table, id: Id) -> ^Table ---
    table_find :: proc(world: ^World, ids: [^]Id, id_count: i32) -> ^Table ---
    table_remove_id :: proc(world: ^World, table: ^Table, id: Id) -> ^Table ---
    table_lock :: proc(world: ^World, table: ^Table) ---
    table_unlock :: proc(world: ^World, table: ^Table) ---
    table_has_module :: proc(table: ^Table) -> c.bool ---
    table_swap_rows :: proc(world: ^World, table: ^Table, row_1: i32, row_2: i32) ---
    commit :: proc(
        world: ^World,
        entity: Entity,
        record: ^Record,
        table: ^Table,
        added: ^Type,
        removed: ^Type,
    ) -> c.bool ---
    record_find :: proc(world: ^World, entity: Entity) -> ^Record ---
    record_get_column :: proc(r: ^Record, column: i32, c_size: Size) -> rawptr ---
    search :: proc(world: ^World, table: ^Table, id: Id, id_out: ^Id = nil) -> i32 ---
    search_offset :: proc(
        world: ^World,
        table: ^Table,
        offset: i32,
        id: Id,
        id_out: ^Id = nil,
    ) -> i32 ---
    search_relation :: proc(
        world: ^World,
        table: ^Table,
        offset: i32,
        id: Id,
        rel: Entity = nil,
        flags: Flags32,
        subject_out: ^Entity,
        id_out: ^Id = nil,
        tr_out: [^]^Table_Record,
    ) -> i32 ---

    // Values
    value_init :: proc(world: ^World, type_: Entity, ptr: rawptr) -> c.int ---
    value_init_w_type_info :: proc(world: ^World, ti: ^Type_Info, ptr: rawptr) -> c.int ---
    value_new :: proc(world: ^World, type_: Entity) -> rawptr ---
    value_new_w_type_info :: proc(world: ^World, ti: ^Type_Info) -> rawptr ---
    value_fini_w_type_info :: proc(world: ^World, ti: ^Type_Info, ptr: rawptr) -> c.int ---
    value_fini :: proc(world: ^World, type_: Entity, ptr: rawptr) -> c.int ---
    value_free :: proc(world: ^World, type_: Entity, ptr: rawptr) -> c.int ---
    value_copy_w_type_info :: proc(
        world: ^World,
        ti: ^Type_Info,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
    value_copy :: proc(
        world: ^World,
        type_: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
    value_move_w_type_info :: proc(
        world: ^World,
        ti: ^Type_Info,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
    value_move :: proc(
        world: ^World,
        type_: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
    value_move_ctor_w_type_info :: proc(
        world: ^World,
        ti: ^Type_Info,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
    value_move_ctor :: proc(
        world: ^World,
        type_: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---
}

// Flecs functions
@(default_calling_convention = "c", link_prefix = "flecs_")
foreign flecs
{
    // Allocator
    allocator_init :: proc(a: ^Allocator) ---
    allocator_fini :: proc(a: ^Allocator) ---
    allocator_get :: proc(a: ^Allocator, size: Size) -> ^Block_Allocator ---
    strdup :: proc(a: ^Allocator, str: cstring) -> cstring ---
    strfree :: proc(a: ^Allocator, str: cstring) ---
    dup :: proc(a: ^Allocator, size: Size, src: rawptr) -> rawptr ---

    // Block_Allocator
    ballocator_init :: proc(ba: ^Block_Allocator, size: Size) ---
    ballocator_new :: proc(size: Size) -> ^Block_Allocator ---
    ballocator_fini :: proc(ba: ^Block_Allocator) ---
    ballocator_free :: proc(ba: ^Block_Allocator) ---
    balloc :: proc(allocator: ^Block_Allocator) -> rawptr ---
    bcalloc :: proc(allocator: ^Block_Allocator) -> rawptr ---
    bfree :: proc(allocator: ^Block_Allocator, memory: rawptr) ---
    brealloc :: proc(dst: ^Block_Allocator, src: ^Block_Allocator, memory: rawptr) -> rawptr ---
    bdup :: proc(ba: ^Block_Allocator, memory: rawptr) -> rawptr ---

    // Sparse
    sparse_set_generation :: proc(sparse: ^Sparse, id: u64) ---
}

/// Externs
@(default_calling_convention = "c")
foreign flecs
{
    ECS_ID_FLAG_BIT: c.ulonglong
    ECS_PAIR: c.ulonglong
    ECS_OVERRIDE: c.ulonglong
    ECS_TOGGLE: c.ulonglong
    ECS_AND: c.ulonglong

    // Builtin component ids
    EcsQuery: Entity
    EcsObserver: Entity

    EcsSystem: Entity
}