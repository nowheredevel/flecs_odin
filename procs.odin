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

    // Log
    _deprecated :: proc(file: cstring, line: i32, msg: cstring) ---
    _log_push :: proc(level: i32) ---
    _log_pop :: proc(level: i32) ---
    _print :: proc(
        level: i32,
        file: cstring,
        line: i32,
        fmt: cstring,
        #c_vararg _: ..any,
    ) ---
    _printv :: proc(
        level: c.int,
        file: cstring,
        line: i32,
        fmt: cstring,
        args: cstring,
    ) ---
    _log :: proc(
        level: i32,
        file: cstring,
        line: i32,
        fmt: cstring,
        #c_vararg _: ..any,
    ) ---
    _logv :: proc(
        level: c.int,
        file: cstring,
        line: i32,
        fmt: cstring,
        args: cstring,
    ) ---
    _abort :: proc(
        error_code: i32,
        file: cstring,
        line: i32,
        fmt: cstring,
        #c_vararg _: ..any,
    ) ---
    _assert :: proc(
        condition: c.bool,
        error_code: i32,
        condition_str: cstring,
        file: cstring,
        line: i32,
        fmt: cstring,
        #c_vararg _: ..any,
    ) -> c.bool ---
    _parser_error :: proc(
        name: cstring,
        expr: cstring,
        column: i64,
        fmt: cstring,
        #c_vararg _: ..any,
    ) ---
    _parser_errorv :: proc(
        name: cstring,
        expr: cstring,
        column: i64,
        fmt: cstring,
        args: cstring,
    ) ---
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
    os_dbg :: proc(file: cstring, line: i32, message: cstring) ---
    os_trace :: proc(file: cstring, line: i32, message: cstring) ---
    os_warn :: proc(file: cstring, line: i32, message: cstring) ---
    os_err :: proc(file: cstring, line: i32, message: cstring) ---
    os_fatal :: proc(file: cstring, line: i32, message: cstring) ---
    os_strerror :: proc(err: c.int) -> cstring ---
    os_strset :: proc(str: [^]cstring, value: cstring) ---
    sleepf :: proc(t: f64) ---
    time_measure :: proc(start: ^Time) -> f64 ---
    time_sub :: proc(t1: Time, t2: Time) -> Time ---
    time_to_double :: proc(t: Time) -> f64 ---
    os_memdup :: proc(src: rawptr, size: Size) -> rawptr ---
    os_has_heap :: proc() -> c.bool ---
    os_has_threading :: proc() -> c.bool ---
    os_has_time :: proc() ->  c.bool ---
    os_has_logging :: proc() -> c.bool ---
    os_has_dl :: proc() -> c.bool ---
    os_has_modules :: proc() -> c.bool ---

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
        rel: Entity,
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

    // App
    app_run :: proc(world: ^World, desc: ^App_Desc) -> c.int ---
    app_run_frame :: proc(world: ^World, desc: ^App_Desc) -> c.int ---
    app_set_run_action :: proc(callback: App_Run_Action) -> c.int ---
    app_set_frame_action :: proc(callback: App_Frame_Action) -> c.int ---

    // Doc
    doc_set_name :: proc(world: ^World, entity: Entity, name: cstring) ---
    doc_set_brief :: proc(world: ^World, entity: Entity, desc: cstring) ---
    doc_set_detail :: proc(world: ^World, entity: Entity, desc: cstring) ---
    doc_set_link :: proc(world: ^World, entity: Entity, link: cstring) ---
    doc_set_color :: proc(world: ^World, entity: Entity, color: cstring) ---
    doc_get_name :: proc(world: ^World, entity: Entity) -> cstring ---
    doc_get_brief :: proc(world: ^World, entity: Entity) -> cstring ---
    doc_get_detail :: proc(world: ^World, entity: Entity) -> cstring ---
    doc_get_link :: proc(world: ^World, entity: Entity) -> cstring ---
    doc_get_color :: proc(world: ^World, entity: Entity) -> cstring ---

    // Expr
    chresc :: proc(out: cstring, in_: c.char, delimiter: c.char) -> cstring ---
    stresc :: proc(out: cstring, size: Size, delimiter: c.char, in_: cstring) -> Size ---
    astresc :: proc(delimiter: c.char, in_: cstring) -> cstring ---
    vars_init :: proc(world: ^World, vars: ^Vars) ---
    vars_fini :: proc(vars: ^Vars) ---
    vars_push :: proc(vars: ^Vars) ---
    vars_pop :: proc(vars: ^Vars) -> c.int ---
    vars_declare :: proc(vars: ^Vars, name: cstring, type_: Entity) -> ^Expr_Var ---
    vars_declare_w_value :: proc(vars: ^Vars, name: cstring, value: ^Value) -> ^Expr_Var ---
    vars_lookup :: proc(vars: ^Vars, name: cstring) -> ^Expr_Var ---
    parse_expr :: proc(
        world: ^World, 
        ptr: cstring, 
        value: ^Value, 
        desc: ^Parse_Expr_Desc,
    ) -> cstring ---
    ptr_to_expr :: proc(world: ^World, type_: Entity, data: rawptr) -> cstring ---
    ptr_to_expr_buf :: proc(
        world: ^World, 
        type_: Entity, 
        data: rawptr, 
        buf: ^StrBuf,
    ) -> c.int ---
    primitive_to_expr_buf :: proc(
        world: ^World,
        kind: Primitive_Kind,
        data: rawptr,
        buf: ^StrBuf,
    ) -> c.int ---
    parse_expr_token :: proc(
        name: cstring,
        expr: cstring,
        ptr: cstring,
        token: cstring,
    ) -> cstring ---

    // HTTP
    http_request_received_count: i64
    http_request_invalid_count: i64
    http_request_handled_ok_count: i64
    http_request_handled_error_count: i64
    http_request_not_handled_count: i64
    http_request_preflight_count: i64
    http_send_ok_count: i64
    http_send_error_count: i64
    http_busy_count: i64

    http_server_init :: proc(desc: ^HTTP_Server_Desc) -> ^HTTP_Server ---
    http_server_fini :: proc(server: ^HTTP_Server) ---
    http_server_start :: proc(server: ^HTTP_Server) -> c.int ---
    http_server_dequeue :: proc(server: ^HTTP_Server, delta_time: FTime) ---
    http_server_stop :: proc(server: ^HTTP_Server) ---
    http_server_http_request :: proc(
        srv: ^HTTP_Server,
        req: cstring,
        len: Size,
        reply_out: ^HTTP_Reply,
    ) -> c.int ---
    http_server_request :: proc(
        srv: ^HTTP_Server,
        method: cstring,
        req: cstring,
        reply_out: ^HTTP_Reply,
    ) -> c.int ---
    http_server_ctx :: proc(srv: ^HTTP_Server) -> rawptr ---
    http_get_header :: proc(req: ^HTTP_Request, name: cstring) -> cstring ---
    http_get_param :: proc(req: ^HTTP_Request, name: cstring) -> cstring ---

    // JSON
    ptr_from_json :: proc(
        world: ^World,
        type_: Entity,
        ptr: rawptr,
        json: cstring,
        desc: ^From_JSON_Desc,
    ) -> cstring ---
    entity_from_json :: proc(
        world: ^World,
        entity: Entity,
        json: cstring,
        desc: ^From_JSON_Desc,
    ) -> cstring ---
    world_from_json :: proc(
        world: ^World,
        json: cstring,
        desc: ^From_JSON_Desc,
    ) -> cstring ---
    array_to_json :: proc(
        world: ^World,
        type_: Entity,
        data: rawptr,
        count: i32,
    ) -> cstring ---
    array_to_json_buf :: proc(
        world: ^World,
        type_: Entity,
        data: rawptr,
        count: i32,
        buf_out: ^StrBuf,
    ) -> c.int ---
    ptr_to_json :: proc(
        world: ^World,
        type_: Entity,
        data: rawptr,
    ) -> cstring ---
    ptr_to_json_buf :: proc(
        world: ^World,
        type_: Entity,
        data: rawptr,
        buf_out: ^StrBuf,
    ) -> c.int ---
    type_info_to_json :: proc(
        world: ^World,
        type_: Entity,
    ) -> cstring ---
    type_info_to_json_buf :: proc(
        world: ^World,
        type_: Entity,
        buf_out: ^StrBuf,
    ) -> c.int ---
    entity_to_json :: proc(
        world: ^World,
        entity: Entity,
        desc: ^Entity_To_JSON_Desc,
    ) -> cstring ---
    entity_to_json_buf :: proc(
        world: ^World,
        entity: Entity,
        buf_out: ^StrBuf,
        desc: ^Entity_To_JSON_Desc,
    ) -> c.int ---
    iter_to_json :: proc(
        world: ^World,
        iter: ^Iter,
        desc: ^Iter_To_JSON_Desc,
    ) -> cstring ---
    iter_to_json_buf :: proc(
        world: ^World,
        iter: ^Iter,
        buf_out: ^StrBuf,
        desc: ^Iter_To_JSON_Desc,
    ) -> c.int ---
    world_to_json :: proc(
        world: ^World,
        desc: ^World_To_JSON_Desc,
    ) -> cstring ---
    world_to_json_buf :: proc(
        world: ^World,
        buf_out: ^StrBuf,
        desc: ^World_To_JSON_Desc,
    ) -> c.int ---

    // Log
    should_log :: proc(level: i32) -> c.bool ---
    strerror :: proc(error_code: i32) -> cstring ---
    log_set_level :: proc(level: c.int) -> c.int ---
    log_get_level :: proc() -> c.int ---
    log_enable_colors :: proc(enabled: c.bool) -> c.bool ---
    log_enable_timestamp :: proc(enabled: c.bool) -> c.bool ---
    log_enable_timedelta :: proc(enabled: c.bool) -> c.bool ---
    log_last_error :: proc() -> c.int ---

    // Meta
    meta_from_desc :: proc(
        world: ^World,
        component: Entity,
        kind: Type_Kind,
        desc: cstring,
    ) -> c.int ---
    meta_cursor :: proc(world: ^World, type_: Entity, ptr: rawptr) -> Meta_Cursor ---
    meta_get_ptr :: proc(cursor: ^Meta_Cursor) -> rawptr ---
    meta_next :: proc(cursor: ^Meta_Cursor) -> c.int ---
    meta_elem :: proc(cursor: ^Meta_Cursor, elem: i32) -> c.int ---
    meta_member :: proc(cursor: ^Meta_Cursor, name: cstring) -> c.int ---
    meta_dotmember :: proc(cursor: ^Meta_Cursor, name: cstring) -> c.int ---
    meta_push :: proc(cursor: ^Meta_Cursor) -> c.int ---
    meta_pop :: proc(cursor: ^Meta_Cursor) -> c.int ---
    meta_is_collection :: proc(cursor: ^Meta_Cursor) -> c.bool ---
    meta_get_type :: proc(cursor: ^Meta_Cursor) -> Entity ---
    meta_get_unit :: proc(cursor: ^Meta_Cursor) -> Entity ---
    meta_get_member :: proc(cursor: ^Meta_Cursor) -> cstring ---
    meta_set_bool :: proc(cursor: ^Meta_Cursor, value: c.bool) -> c.int ---
    meta_set_char :: proc(cursor: ^Meta_Cursor, value: c.char) -> c.int ---
    meta_set_int :: proc(cursor: ^Meta_Cursor, value: i64) -> c.int ---
    meta_set_uint :: proc(cursor: ^Meta_Cursor, value: u64) -> c.int ---
    meta_set_float :: proc(cursor: ^Meta_Cursor, value: f64) -> c.int ---
    meta_set_string :: proc(cursor: ^Meta_Cursor, value: cstring) -> c.int ---
    meta_set_string_literal :: proc(cursor: ^Meta_Cursor, value: cstring) -> c.int ---
    meta_set_entity :: proc(cursor: ^Meta_Cursor, value: Entity) -> c.int ---
    meta_set_null :: proc(cursor: ^Meta_Cursor) -> c.int ---
    meta_set_value :: proc(cursor: ^Meta_Cursor, value: ^Value) -> c.int ---
    meta_get_bool :: proc(cursor: ^Meta_Cursor) -> c.bool ---
    meta_get_char :: proc(cursor: ^Meta_Cursor) -> c.char ---
    meta_get_int :: proc(cursor: ^Meta_Cursor) -> i64 ---
    meta_get_uint :: proc(cursor: ^Meta_Cursor) -> u64 ---
    meta_get_float :: proc(cursor: ^Meta_Cursor) -> f64 ---
    meta_get_string :: proc(cursor: ^Meta_Cursor) -> cstring ---
    meta_get_entity :: proc(cursor: ^Meta_Cursor) -> Entity ---
    meta_ptr_to_float :: proc(type_kind: Primitive_Kind, ptr: rawptr) -> f64 ---
    primitive_init :: proc(world: ^World, desc: ^Primitive_Desc) -> Entity ---
    enum_init :: proc(world: ^World, desc: ^Enum_Desc) -> Entity ---
    bitmask_init :: proc(world: ^World, desc: ^Bitmask_Desc) -> Entity ---
    array_init :: proc(world: ^World, desc: ^Array_Desc) -> Entity ---
    vector_init :: proc(world: ^World, desc: ^Vector_Desc) -> Entity ---
    struct_init :: proc(world: ^World, desc: ^Struct_Desc) -> Entity ---
    opaque_init :: proc(world: ^World, desc: ^Opaque_Desc) -> Entity ---
    unit_init :: proc(world: ^World, desc: ^Unit_Desc) -> Entity ---
    unit_prefix_init :: proc(world: ^World, desc: ^Unit_Prefix_Desc) -> Entity ---
    quantity_init :: proc(world: ^World, desc: ^Entity_Desc) -> Entity ---

    // Metrics
    metric_init :: proc(world: ^World, desc: ^Metric_Desc) -> Entity ---

    // Module
    @(link_name="import") import_module :: proc(
        world: ^World,
        module: Module_Action,
        module_name: cstring,
    ) -> Entity ---
    import_c :: proc(
        world: ^World,
        module: Module_Action,
        module_name_c: cstring,
    ) -> Entity ---
    import_from_library :: proc(
        world: ^World,
        library_name: cstring,
        module_name: cstring,
    ) -> Entity ---
    module_init :: proc(
        world: ^World,
        c_name: cstring,
        desc: ^Component_Desc,
    ) -> Entity ---

    // OS API Impl
    set_os_api_impl :: proc() ---

    // Parser
    parse_ws :: proc(ptr: cstring) -> cstring ---
    parse_ws_eol :: proc(ptr: cstring) -> cstring ---
    parse_identifier :: proc(
        name: cstring,
        expr: cstring,
        ptr: cstring,
        token_out: cstring,
    ) -> cstring ---
    parse_digit :: proc(
        ptr: cstring,
        token: cstring,
    ) -> cstring ---
    parse_token :: proc(
        name: cstring,
        expr: cstring,
        ptr: cstring,
        token_out: cstring,
        delim: c.char,
    ) -> cstring ---
    parse_term :: proc(
        world: ^World,
        name: cstring,
        expr: cstring,
        ptr: cstring,
        term_out: ^Term,
    ) -> cstring ---

    // Pipeline
    pipeline_init :: proc(world: ^World, desc: ^Pipeline_Desc) -> Entity ---
    set_pipeline :: proc(world: ^World, pipeline: Entity) ---
    get_pipeline :: proc(world: ^World) -> Entity ---
    progress :: proc(world: ^World, delta_time: FTime) -> c.bool ---
    set_time_scale :: proc(world: ^World, scale: FTime) ---
    reset_clock :: proc(world: ^World) ---
    run_pipeline :: proc(world: ^World, pipeline: Entity, delta_time: FTime) ---
    set_threads :: proc(world: ^World, threads: i32) ---
    
    // Plecs
    plecs_from_str :: proc(world: ^World, name: cstring, str: cstring) -> c.int ---
    plecs_from_file :: proc(world: ^World, filename: cstring) -> c.int ---
    script_init :: proc(world: ^World, desc: ^Script_Desc) -> Entity ---
    script_update :: proc(
        world: ^World,
        script: Entity,
        instance: Entity,
        str: cstring,
        vars: ^Vars,
    ) -> c.int ---
    script_clear :: proc(world: ^World, script: Entity, instance: Entity) ---

    // REST
    rest_server_init :: proc(world: ^World, desc: ^HTTP_Server_Desc) -> ^HTTP_Server ---
    rest_server_fini :: proc(srv: ^HTTP_Server) ---

    // Rules
    rule_init :: proc(world: ^World, desc: ^Filter_Desc) -> ^Rule ---
    rule_fini :: proc(rule: ^Rule) ---
    rule_get_filter :: proc(rule: ^Rule) -> ^Filter ---
    rule_var_count :: proc(rule: ^Rule) -> i32 ---
    rule_find_var :: proc(rule: ^Rule, name: cstring) -> i32 ---
    rule_var_name :: proc(rule: ^Rule, var_id: i32) -> cstring ---
    rule_var_is_entity :: proc(rule: ^Rule, var_id: i32) -> c.bool ---
    rule_iter :: proc(world: ^World, rule: ^Rule) -> Iter ---
    rule_next :: proc(it: ^Iter) -> c.bool ---
    rule_next_instanced :: proc(it: ^Iter) -> c.bool ---
    rule_str :: proc(rule: ^Rule) -> cstring ---
    rule_str_w_profile :: proc(rule: ^Rule, it: ^Iter) -> cstring ---
    rule_parse_vars :: proc(rule: ^Rule, it: ^Iter, expr: cstring) -> cstring ---
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
    @(link_name="EcsQuery") Ecs_Query: Entity
    @(link_name="EcsObserver") Ecs_Observer: Entity

    @(link_name="EcsSystem") Ecs_System: Entity
    @(link_name="EcsFlag") Ecs_Flag: Entity
    @(link_name="EcsFlecsInternals") Ecs_Flecs_Internals: Entity

    // Doc entities
    @(link_name="DocBrief") Doc_Brief: Entity
    @(link_name="DocDetail") Doc_Detail: Entity
    @(link_name="DocLink") Doc_Link: Entity
    @(link_name="DocColor") Doc_Color: Entity

    // Global OS API
    @(link_name="ecs_os_api") Global_OS_API: OS_API

    @(link_name="EcsConstant") Ecs_Constant: Entity
    @(link_name="EcsQuantity") Ecs_Quantity: Entity

    @(link_name="EcsPeriod1s") Ecs_Period_1s: Entity
    @(link_name="EcsPeriod1m") Ecs_Period_1m: Entity
    @(link_name="EcsPeriod1h") Ecs_Period_1h: Entity
    @(link_name="EcsPeriod1d") Ecs_Period_1d: Entity
    @(link_name="EcsPeriod1w") Ecs_Period_1w: Entity

    rest_request_count: i64
    rest_entity_count: i64
    rest_entity_error_count: i64
    rest_query_count: i64
    rest_query_error_count: i64
    rest_query_name_count: i64
    rest_query_name_error_count: i64
    rest_query_name_from_cache_count: i64
    rest_enable_count: i64
    rest_enable_error_count: i64
    rest_delete_count: i64
    rest_delete_error_count: i64
    rest_world_stats_count: i64
    rest_pipeline_stats_count: i64
    rest_stats_error_count: i64
}

/// Module imports
@(default_calling_convention = "c", link_prefix = "Flecs")
foreign flecs
{
    DocImport :: proc(world: ^World) ---
    MetaImport :: proc(world: ^World) ---
    MetricsImport :: proc(world: ^World) ---
    MonitorImport :: proc(world: ^World) ---
    PipelineImport :: proc(world: ^World) ---
    ScriptImport :: proc(world: ^World) ---
    RestImport :: proc(world: ^World) ---
}