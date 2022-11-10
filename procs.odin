package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "system:flecs.lib"
}

@(default_calling_convention = "c", link_prefix = "_ecs", private)
foreign flecs
{
    // Vector
    _vector_new :: proc(elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> ^Vector ---
    _vector_from_array :: proc(elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t, array: [^]rawptr) -> ^Vector ---
    _vector_zero :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t) ---
    _vector_add :: proc(array_inout: [^]Vector, elem_size: size_t, offset: c.int16_t) -> rawptr ---
    _vector_insert_at :: proc(array_inout: [^]Vector, elem_size: size_t, offset: c.int16_t, index: c.int32_t) -> rawptr ---
    _vector_addn :: proc(array_inout: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> rawptr ---
    _vector_get :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t, index: c.int32_t) -> rawptr ---
    _vector_last :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t) -> rawptr ---
    _vector_set_min_size :: proc(array_inout: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> c.int32_t ---
    _vector_set_min_count :: proc(vector_inout: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> c.int32_t ---
    _vector_pop :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t, value: rawptr) -> bool ---
    _vector_move_index :: proc(dst: [^]Vector, src: ^Vector, elem_size: size_t, offset: c.int16_t, index: c.int32_t) -> c.int32_t ---
    _vector_remove :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t, index: c.int32_t) -> c.int32_t ---
    _vector_reclaim :: proc(vector: [^]Vector, elem_size: size_t, offset: c.int16_t) ---
    _vector_grow :: proc(vector: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> c.int32_t ---
    _vector_set_size :: proc(vector: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> c.int32_t ---
    _vector_set_count :: proc(vector: [^]Vector, elem_size: size_t, offset: c.int16_t, elem_count: c.int32_t) -> c.int32_t ---
    _vector_first :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t) -> rawptr ---
    _vector_sort :: proc(vector: ^Vector, elem_size: size_t, offset: c.int16_t, compare_action: comparator_t) ---
    _vector_copy :: proc(src: ^Vector, elem_size: size_t, offset: c.int16_t) -> ^Vector ---

    // Sparse
    _sparse_new :: proc(elem_size: size_t) -> ^Sparse ---
    _sparse_add :: proc(sparse: ^Sparse, elem_size: size_t) -> rawptr ---
    _sparse_get_dense :: proc(sparse: ^Sparse, elem_size: size_t, index: c.int32_t) -> rawptr ---
    _sparse_get :: proc(sparse: ^Sparse, elem_size: size_t, id: c.uint64_t) -> rawptr ---
    
    // Map
    _map_params_init :: proc(params: ^MapParams, allocator: ^Allocator, elem_size: size_t) ---
    _map_init :: proc(map_t: ^Map, elem_size: size_t, allocator: ^Allocator, initial_count: c.int32_t) ---
    _map_init_w_params :: proc(map_t: ^Map, params: ^MapParams) ---
    _map_init_if :: proc(map_t: ^Map, elem_size: size_t, allocator: ^Allocator, elem_count: c.int32_t) ---
    _map_init_w_params_if :: proc(result: ^Map, params: ^MapParams) ---
    _map_new :: proc(elem_size: size_t, allocator: ^Allocator, elem_count: c.int32_t) -> ^Map ---
    _map_get :: proc(map_t: ^Map, elem_size: size_t, key: map_key_t) -> rawptr ---
    _map_get_ptr :: proc(map_t: ^Map, key: map_key_t) -> rawptr ---
    _map_ensure :: proc(map_t: ^Map, elem_size: size_t, key: map_key_t) -> rawptr ---
    _map_set :: proc(map_t: ^Map, elem_size: size_t, key: map_key_t, payload: rawptr) -> rawptr ---
    _map_next :: proc(iter: ^MapIter, elem_size: size_t, key: ^map_key_t) -> rawptr ---
    _map_next_ptr :: proc(iter: ^MapIter, key: ^map_key_t) -> rawptr ---

    // Tracing
    _deprecated :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    _log_push :: proc(level: c.int32_t) ---
    _log_pop :: proc(level: c.int32_t) ---
    
    // Logging
    _log :: proc(level: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring) ---
    _logv :: proc(level: c.int, file: cstring, line: c.int32_t, fmt: cstring, args: va_list) ---
    _abort :: proc(error_code: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring) ---
    _assert :: proc(condition: c.bool, error_code: c.int32_t, condition_str: cstring, file: cstring, line: c.int32_t, fmt: cstring, args: ..any) -> c.bool ---
    _parser_error :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, args: ..any) ---
    _parser_errorv :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, args: va_list) ---

}

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // Vector


    // Free vector
    vector_free :: proc(vector: ^Vector) ---
    // Clear values in vector
    vector_clear :: proc(vector: ^Vector) ---
    // Assert when the provided size does not match the vector type
    vector_assert_size :: proc(vector_inout: ^Vector, elem_size: size_t) ---
    // Remove last element. This operation requires no swapping of values
    vector_remove_last :: proc(vector: ^Vector) ---
    // Return number of elements in vector.
    vector_count :: proc(vector: ^Vector) -> c.int32_t ---
    // Return size of vector.
    vector_size :: proc(vector: ^Vector) -> c.int32_t ---

    // Sparse


    sparse_last_id :: proc(sparse: ^Sparse) -> c.uint64_t ---
    sparse_count :: proc(sparse: ^Sparse) -> c.int32_t ---

    // Map


    map_params_fini :: proc(params: ^MapParams) ---
    map_fini :: proc(map_t: ^Map) ---
    map_is_initialized :: proc(result: ^Map) -> bool ---
    // Test if map has key
    map_has :: proc(map_t: ^Map, key: map_key_t) -> bool ---
    // Free map.
    map_free :: proc(map_t: ^Map) ---
    // Remove key from map, returns number of remaining elements
    map_remove :: proc(map_t: ^Map, key: map_key_t) -> c.int32_t ---
    // Remove all elements from map.
    map_clear :: proc(map_t: ^Map) ---
    // Return number of elements in map.
    map_count :: proc(map_t: ^Map) -> c.int32_t ---
    // Return number of buckets in map.
    map_bucket_count :: proc(map_t: ^Map) -> c.int32_t ---
    // Return iterator to map contents.
    map_iter :: proc(map_t: ^Map) -> MapIter ---
    // Grow number of buckets in the map for specified number of elements.
    map_grow :: proc(map_t: ^Map, elem_count: c.int32_t) ---
    // Set number of buckets in the map for specified number of elements.
    map_set_size :: proc(map_t: ^Map, elem_count: c.int32_t) ---
    // Copy map.
    map_copy :: proc(map_t: ^Map) -> ^Map ---

    // StrBuf


    // Append format string to a buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_append :: proc(buffer: ^StrBuf, fmt: cstring) -> bool ---

    // Append format string with argument list to a buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_vappend :: proc(buffer: ^StrBuf, fmt: cstring, args: va_list) -> bool ---

    // Append string to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> bool ---

    // Append character to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> bool ---

    // Append int to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendint :: proc(buffer: ^StrBuf, v: c.int64_t) -> bool ---

    // Append float to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendflt :: proc(buffer: ^StrBuf, v: c.double, nan_delim: c.char) -> bool ---

    // Append source buffer to destination buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_mergebuff :: proc(dst_buffer: ^StrBuf, src_buffer: ^StrBuf) -> bool ---

    // Append string to buffer, transfer ownership to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendstr_zerocpy :: proc(buffer: ^StrBuf, str: cstring) -> bool ---

    // Append string to buffer, do not free/modify string.
    // Returns false when max is reached, true when there is still space
    strbuf_appendstr_zerocpy_const :: proc(buffer: ^StrBuf, str: cstring) -> bool ---

    // Append n characters to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: c.int32_t) -> bool ---

    // Return result string
    strbuf_get :: proc(buffer: ^StrBuf) -> cstring ---

    // Return small string from first element (appends \0)
    strbuf_get_small :: proc(buffer: ^StrBuf) -> cstring ---

    // Reset buffer without returning a string
    strbuf_reset :: proc(buffer: ^StrBuf) ---

    // Push a list
    strbuf_list_push :: proc(buffer: ^StrBuf, list_open: cstring, separator: cstring) ---

    // Pop a new list
    strbuf_list_pop :: proc(buffer: ^StrBuf, list_close: cstring) ---

    // Insert a new element in list
    strbuf_list_next :: proc(buffer: ^StrBuf) ---

    // Append character to as new element in list
    strbuf_list_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> bool ---

    // Append formatted string as new element in list
    strbuf_list_append :: proc(buffer: ^StrBuf, fmt: cstring, args: ..any) -> bool ---

    // Append string as new element in list
    strbuf_list_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> bool ---

    // Append string as new element in list
    strbuf_list_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: c.int32_t) -> bool ---

    strbuf_written :: proc(buffer: ^StrBuf) -> c.int32_t ---

    // OSApi
    

    os_init :: proc() ---
    os_fini :: proc() ---
    os_set_api :: proc(os_api: ^OSApi) ---
    os_get_api :: proc() -> OSApi ---
    os_set_api_defaults :: proc() ---

    // Logging
    os_dbg :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_trace :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_warn :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_err :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_fatal :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_strerror :: proc(err: c.int) -> cstring ---
    sleepf :: proc(t: c.double) ---
    time_measure :: proc(start: ^Time) -> c.double ---
    time_sub :: proc(t1: Time, t2: Time) -> Time ---
    time_to_double :: proc(t: Time) -> c.double ---
    os_memdup :: proc(src: rawptr, size: size_t) -> rawptr ---
    os_has_heap :: proc() -> bool ---
    os_has_threading :: proc() -> bool ---
    os_has_time :: proc() -> bool ---
    os_has_logging :: proc() -> bool ---
    os_has_dl :: proc() -> bool ---
    os_has_modules :: proc() -> bool ---


    // Vec
    vec_init :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) -> ^Vec ---
    vec_fini :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) ---
    vec_clear :: proc(vec: ^Vec) ---
    vec_append :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) -> rawptr ---
    vec_remove :: proc(vec: ^Vec, size: size_t, elem: c.int32_t) ---
    vec_remove_last :: proc(vec: ^Vec) ---
    vec_copy :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) -> Vec ---
    vec_reclaim :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) ---
    vec_set_size :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_count :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_grow :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) -> rawptr ---
    vec_count :: proc(vec: ^Vec) -> c.int32_t ---
    vec_size :: proc(vec: ^Vec) -> c.int32_t ---
    vec_get :: proc(vec: ^Vec, size: size_t, index: c.int32_t) -> rawptr ---
    vec_first :: proc(vec: ^Vec) -> rawptr ---
    vec_last :: proc(vec: ^Vec, size: size_t) -> rawptr ---


    // API support
    module_path_from_c :: proc(c_name: cstring) -> cstring ---
    default_ctor :: proc(ptr: rawptr, count: c.int32_t, ctx: ^TypeInfo) ---


    // World API


    // Create a new world
    init :: proc() -> ^World ---

    // Create a new world, but with a minimal set of modules loaded
    mini :: proc() -> ^World ---

    // Create a new world with args
    init_w_args :: proc(argc: c.int, argv: []cstring) -> ^World ---

    // Delete a world
    fini :: proc(world: ^World) -> c.int ---

    // Returns whether the world is being deleted
    is_fini :: proc(world: ^World) -> c.bool ---

    // Register action to be executed when world is destroyed
    atfini :: proc(world: ^World, action: fini_action_t, ctx: rawptr) ---

    // Register action to be executed once after frame.
    run_post_frame :: proc(world: ^World, action: fini_action_t, ctx: rawptr) ---

    // Signal exit
    quit :: proc(world: ^World) ---

    // Return whether a quit has signaled
    should_quit :: proc(world: ^World) -> c.bool ---

    // Register hooks for component
    set_hooks_id :: proc(world: ^World, id: Entity, hooks: ^TypeHooks) ---

    // Get hooks for component
    get_hooks_id :: proc(world: ^World, id: Entity) -> ^TypeHooks ---

    // Set a world context
    set_context :: proc(world: ^World, ctx: rawptr) ---

    // Get the world context
    get_context :: proc(world: ^World) -> rawptr ---

    // Get world info
    get_world_info :: proc(world: ^World) -> ^WorldInfo ---

    // Dimension the world for a specified number of entities
    dim :: proc(world: ^World, entity_count: c.int32_t) ---

    // Set a range for issuing new entity ids
    set_entity_range :: proc(world: ^World, id_start: Entity, id_end: Entity) ---

    // Sets the entity's generation in the world's sparse set
    set_entity_generation :: proc(world: ^World, entity_with_generation: Entity) ---

    // Enable/disable range limits
    enable_range_check :: proc(world: ^World, enable: c.bool) -> c.bool ---

    // Measure frame time
    measure_frame_time :: proc(world: ^World, enable: c.bool) ---

    // Measure system time
    measure_system_time :: proc(world: ^World, enable: c.bool) ---

    // Set target frames per second (FPS) for application
    set_target_fps :: proc(world: ^World, fps: ftime_t) ---

    // Force aperiodic actions
    run_aperiodic :: proc(world: ^World, flags: flags32_t) ---

    // Cleanup empty tables
    delete_empty_tables :: proc(
        world: ^World,
        id: id_t,
        clear_generation: c.uint16_t,
        delete_generation: c.uint16_t,
        min_id_count: c.int32_t,
        time_budget_seconds: c.double,
    ) -> c.int32_t ---

    // Create new entity id
    new_id :: proc(world: ^World) -> Entity ---

    // Create new low id
    new_low_id :: proc(world: ^World) -> Entity ---

    // Create new entity
    new_w_id :: proc(world: ^World, id: id_t) -> Entity ---

    // Find or create an entity
    entity_init :: proc(world: ^World, desc: ^EntityDesc) -> Entity ---

    // Bulk create/populate new entities
    bulk_init :: proc(world: ^World, desc: ^BulkDesc) -> [^]Entity ---

    // Find or create a component
    component_init :: proc(world: ^World, desc: ^ComponentDesc) -> Entity ---

    // Create N new entities
    bulk_new_w_id :: proc(world: ^World, id: id_t, count: c.int32_t) -> ^Entity ---

    // Clone an entity
    clone :: proc(world: ^World, dst: Entity, src: Entity, copy_value: c.bool) -> Entity ---

    
    // Adding and Removing


    // Add a (component) id to an entity
    add_id :: proc(world: ^World, entity: Entity, id: id_t) ---

    // Remove a (component) id from an entity
    remove_id :: proc(world: ^World, entity: Entity, id: id_t) ---

    // Add override for (component) id
    override_id :: proc(world: ^World, entity: Entity, id: id_t) ---


    // Enabling and Disabling components


    // Enable or disable component
    enable_id :: proc(world: ^World, entity: Entity, id: id_t, enable: c.bool) ---

    // Test if component is enabled
    is_enabled_id :: proc(world: ^World, entity: Entity, id: id_t) -> c.bool ---


    // Pairs


    // Make a pair id
    make_pair :: proc(first: Entity, second: Entity) -> id_t ---


    // Deleting Entities and components


    // Clear all components
    clear :: proc(world: ^World, entity: Entity) ---

    // Delete an entity
    delete :: proc(world: ^World, entity: Entity) ---

    // Delete all entities with the specified id
    delete_with :: proc(world: ^World, id: id_t) ---

    // Remove all instances of the specific id
    remove_all :: proc(world: ^World, id: id_t) ---


    // Getting components


    // Get an immutable pointer to a component
    get_id :: proc(world: ^World, entity: Entity, id: id_t) -> rawptr ---

    // Create a component ref
    ref_init_id :: proc(world: ^World, entity: Entity, id: id_t) -> Ref ---

    // Get component from ref
    ref_get_id :: proc(world: ^World, ref: ^Ref, id: id_t) -> rawptr ---

    // Update ref
    ref_update :: proc(world: ^World, ref: ^Ref) ---


    // Setting Components


    // Get a mutable pointer to a component
    get_mut_id :: proc(world: ^World, entity: Entity, id: id_t) -> rawptr ---

    // Begin exclusive write access to entity
    write_begin :: proc(world: ^World, entity: Entity) -> ^Record ---

    // End exclusive write access to entity
    write_end :: proc(record: ^Record) ---

    // Begin read access to entity
    read_begin :: proc(world: ^World, entity: Entity) -> ^Record ---

    // End read access to entity
    read_end :: proc(record: ^Record) ---

    // Get component from entity record
    record_get_id :: proc(world: ^World, record: ^Record, id: id_t) -> rawptr ---

    // Same as record_get_id, but returns a mutable pointer (syntactically the same)
    record_get_mut_id :: proc(world: ^World, record: ^Record, id: id_t) -> rawptr ---

    // Emplace a component
    emplace_id :: proc(world: ^World, entity: Entity, id: id_t) -> rawptr ---

    // Signal that a component has been modified
    modified_id :: proc(world: ^World, entity: Entity, id: id_t) ---

    // Set the value of a component
    set_id :: proc(world: ^World, entity: Entity, id: id_t, size: size_t, ptr: rawptr) -> Entity ---


    // Entity Metadata


    // Test whether an entity is valid
    is_valid :: proc(world: ^World, e: Entity) -> c.bool ---

    // Test whether an entity is alive
    is_alive :: proc(world: ^World, e: Entity) -> c.bool ---

    // Remove generation from entity id
    strip_generation :: proc(e: Entity) -> id_t ---

    // Get alive identifier
    get_alive :: proc(world: ^World, e: Entity) -> Entity ---

    // Ensure id is alive
    ensure :: proc(world: ^World, entity: Entity) ---

    // Ensure component id can be used
    ensure_id :: proc(world: ^World, id: id_t) ---

    // Test whether an entity exists
    exists :: proc(world: ^World, entity: Entity) -> c.bool ---

    // Get the type of an entity
    get_type :: proc(world: ^World, entity: Entity) -> ^Type ---

    // Get the table of an entity
    get_table :: proc(world: ^World, entity: Entity) -> ^Table ---

    // Get the storage table of an entity
    get_storage_table :: proc(world: ^World, entity: Entity) -> ^Table ---

    // Get the type info for an id
    get_type_info :: proc(world: ^World, id: id_t) -> ^TypeInfo ---

    // Get the type for an id
    get_typeid :: proc(world: ^World, id: id_t) -> Entity ---

    // Returns whether specified id is a tag
    id_is_tag :: proc(world: ^World, id: id_t) -> Entity ---

    // Returns whether specified id is in use
    id_in_use :: proc(world: ^World, id: id_t) -> c.bool ---

    // Get the name of an entity
    get_name :: proc(world: ^World, entity: Entity) -> cstring ---

    // Get the symbol of an entity
    get_symbol :: proc(world: ^World, entity: Entity) -> cstring ---

    // Set the name of an entity
    set_name :: proc(world: ^World, entity: Entity, name: cstring) -> Entity ---

    // Set the symbol of an entity
    set_symbol :: proc(world: ^World, entity: Entity, symbol: cstring) -> Entity ---

    // Set alias for entity
    set_alias :: proc(world: ^World, entity: Entity, alias: cstring) ---

    // Convert id flag to string
    id_flag_str :: proc(id_flags: id_t) -> cstring ---

    // Convert id to string
    id_str :: proc(world: ^World, id: id_t) -> cstring ---

    // Write id string to buffer
    id_str_buf :: proc(world: ^World, id: id_t, buf: ^StrBuf) ---

    // Convert type to string
    type_str :: proc(world: ^World, type: ^Type) -> cstring ---

    // Convert table to string
    table_str :: proc(world: ^World, table: ^Table) -> cstring ---

    // Convert entity to string
    entity_str :: proc(world: ^World, entity: Entity) -> cstring ---

    // Test if an entity has an entity
    has_id :: proc(world: ^World, entity: Entity, id: id_t) -> c.bool ---

    // Get the target of a relationship
    get_target :: proc(
        world: ^World, 
        entity: Entity, 
        rel: Entity, 
        index: c.int32_t,
    ) -> Entity ---

    // Get the target of a relationship for a given id
    get_target_for_id :: proc(
        world: ^World, 
        entity: Entity, 
        rel: Entity, 
        id: id_t,
    ) -> Entity ---

    // Enable or disable an entity
    enable :: proc(world: ^World, entity: Entity, enabled: c.bool) ---

    // Count entities that have the specified id
    count_id :: proc(world: ^World, entity: id_t) -> c.int32_t ---


    // Lookups


    // Lookup an entity by name
    lookup :: proc(world: ^World, name: cstring) -> Entity ---

    // Lookup a child entity by name
    lookup_child :: proc(world: ^World, parent: Entity, name: cstring) -> Entity ---

    // Lookup an entity from a path
    lookup_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
        recursive: c.bool,
    ) -> Entity ---

    // Lookup an entity by its symbol name
    lookup_symbol :: proc(world: ^World, symbol: cstring, lookup_as_path: c.bool) -> Entity ---


    // Paths


    // Get a path identifier for an entity
    get_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        child: Entity,
        sep: cstring,
        prefix: cstring,
    ) -> cstring ---

    // Write path identifier to buffer
    get_path_w_sep_buf :: proc(
        world: ^World,
        parent: Entity,
        child: Entity,
        sep: cstring,
        prefix: cstring,
        buf: ^StrBuf,
    ) ---

    // Find or create entity from path
    new_from_path_w_sep :: proc(
        world: ^World,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
    ) -> Entity ---

    // Add specified path to entity
    add_path_w_sep :: proc(
        world: ^World,
        entity: Entity,
        parent: Entity,
        path: cstring,
        sep: cstring,
        prefix: cstring,
    ) -> Entity ---


    // Scopes


    // Set the current scope
    set_scope :: proc(world: ^World, scope: Entity) -> Entity ---

    // Get the current scope
    get_scope :: proc(world: ^World) -> Entity ---

    // Set current with id
    set_with :: proc(world: ^World, id: id_t) -> Entity ---

    // Get current with id
    get_with :: proc(world: ^World) -> id_t ---

    // Set a name prefix for newly created entities
    set_name_prefix :: proc(world: ^World, prefix: cstring) -> cstring ---

    // Set search path for lookup operations
    set_lookup_path :: proc(world: ^World, lookup_path: [^]Entity) -> [^]Entity ---

    // Get current lookup path
    get_lookup_path :: proc(world: ^World) -> [^]Entity ---


    // Terms


    // Iterator for a single (component) id
    term_iter :: proc(world: ^World, term: ^Term) -> Iter ---

    // Return a chained term iterator
    term_chain_iter :: proc(it: ^Iter, term: ^Term) -> Iter ---

    // Progress a term iterator
    term_next :: proc(it: ^Iter) -> c.bool ---

    // Iterator for a parent's children
    children :: proc(world: ^World, parent: Entity) -> Iter ---

    // Progress a children iterator
    children_next :: proc(it: ^Iter) -> c.bool ---

    // Test whether term id is set
    term_id_is_set :: proc(id: ^TermId) -> c.bool ---

    // Test whether a term is set
    term_is_initialized :: proc(term: ^Term) -> c.bool ---

    term_match_this :: proc(term: ^Term) -> c.bool ---

    term_match_0 :: proc(term: ^Term) -> c.bool ---

    // Finalize term
    term_finalize :: proc(world: ^World, term: ^Term) -> c.int ---

    // Copy resources of a term to another term
    term_copy :: proc(src: ^Term) -> Term ---

    // Move resources of a term to another term
    term_move :: proc(src: ^Term) -> Term ---

    // Free resources of term
    term_fini :: proc(term: ^Term) ---

    // Utility to match an id with a pattern
    id_match :: proc(id: id_t, pattern: id_t) -> c.bool ---

    // Utility to check if id is a pair
    id_is_pair :: proc(id: id_t) -> c.bool ---

    // Utility to check if id is a wildcard
    id_is_wildcard :: proc(id: id_t) -> c.bool ---

    // Utility to check if id is valid
    id_is_valid :: proc(world: ^World, id: id_t) -> c.bool ---

    // Get flags associated with id
    id_get_flags :: proc(world: ^World, id: id_t) -> flags32_t ---


    // Filters


    // Initialize filter
    filter_init :: proc(world: ^World, desc: ^FilterDesc) -> ^Filter ---

    // Deinitialize filter
    filter_fini :: proc(filter: ^Filter) ---

    // Finalize filter
    filter_finalize :: proc(world: ^World, filter: ^Filter) -> c.int ---

    // Find index for this variable
    filter_find_this_var :: proc(filter: ^Filter) -> c.int32_t ---

    // Convert term to string expression
    term_str :: proc(world: ^World, term: ^Term) -> cstring ---

    // Convert filter to string expression
    filter_str :: proc(world: ^World, filter: ^Filter) -> cstring ---

    // Return a filter iterator
    filter_iter :: proc(world: ^World, filter: ^Filter) -> Iter ---

    // Return a chained filter iterator
    filter_chain_iter :: proc(it: ^Iter, filter: ^Filter) -> Iter ---

    // Get pivot term for filter
    filter_pivot_term :: proc(world: ^World, filter: ^Filter) -> c.int32_t ---

    // Iterate tables matched by filter
    filter_next :: proc(it: ^Iter) -> c.bool ---

    // Same as filter_next, but always instanced
    filter_next_instanced :: proc(it: ^Iter) -> c.bool ---

    // Move resources of one filter to another
    filter_move :: proc(dst: ^Filter, src: ^Filter) ---

    // Copy resources of one filter to another
    filter_copy :: proc(dst: ^Filter, src: ^Filter) ---


    // Queries


    // Create a query
    query_init :: proc(world: ^World, desc: ^QueryDesc) -> ^Query ---

    // Destroy a query
    query_fini :: proc(query: ^Query) ---

    // Get filter from a query
    query_get_filter :: proc(query: ^Query) -> ^Filter ---

    // Return a query iterator
    query_iter :: proc(world: ^World, query: ^Query) -> Iter ---

    // Progress the query iterator
    query_next :: proc(iter: ^Iter) -> c.bool ---

    // Same as query_next, but always instanced
    query_next_instanced :: proc(iter: ^Iter) -> c.bool ---

    // Alternative to query_next that only returns matched tables
    query_next_table :: proc(iter: ^Iter) -> c.bool ---

    // Populate iterator fields
    query_populate :: proc(iter: ^Iter) ---

    // Returns whether the query data changed since the last iteration
    query_changed :: proc(query: ^Query, it: ^Iter) -> c.bool ---

    // Skip a table while iterating
    query_skip :: proc(it: ^Iter) ---

    // Set group to iterate for query iterator
    query_set_group :: proc(it: ^Iter, group_id: c.uint64_t) ---

    // Get context of query group
    query_get_group_ctx :: proc(query: ^Query, group_id: c.uint64_t) -> rawptr ---

    // Get information about query group
    query_get_group_info :: proc(query: ^Query, group_id: c.uint64_t) -> ^QueryGroupInfo ---

    // Returns whether query is orphaned
    query_orphaned :: proc(query: ^Query) -> c.bool ---

    // Convert query to string
    query_str :: proc(query: ^Query) -> cstring ---

    // Returns number of tables query matched with
    query_table_count :: proc(query: ^Query) -> c.int32_t ---

    // Returns number of empty tables query matched with
    query_empty_table_count :: proc(query: ^Query) -> c.int32_t ---

    // Returns number of entities query matched with
    query_entity_count :: proc(query: ^Query) -> c.int32_t ---

    // Get entity associated with query
    query_entity :: proc(query: ^Query) -> Entity ---

    
    // Observers


    // Send event
    emit :: proc(world: ^World, desc: ^EventDesc) ---

    // Create observer
    observer_init :: proc(world: ^World, desc: ^ObserverDesc) -> Entity ---

    // Default run action for observer
    observer_default_run_action :: proc(it: ^Iter) -> c.bool ---

    get_observer_ctx :: proc(world: ^World, observer: Entity) -> rawptr ---

    get_observer_binding_ctx :: proc(world: ^World, observer: Entity) -> rawptr ---


    // Iterators


    // Create iterator from poly object
    iter_poly :: proc(
        world: ^World,
        poly: ^poly_t,
        iter: ^Iter,
        filter: ^Term,
    ) ---

    // Progress any iterator
    iter_next :: proc(it: ^Iter) -> c.bool ---

    // Cleanup iterator resources
    iter_fini :: proc(it: ^Iter) ---

    // Count number of matched entities in query
    iter_count :: proc(it: ^Iter) -> c.int32_t ---

    // Test if iterator is true
    iter_is_true :: proc(it: ^Iter) -> c.bool ---

    // Set value for iterator variable
    iter_set_var :: proc(
        it: ^Iter, 
        var_id: c.int32_t, 
        entity: Entity,
    ) ---

    // Same as iter_set_var, but for a table
    iter_set_var_as_table :: proc(
        it: ^Iter,
        var_id: c.int32_t,
        table: ^Table,
    ) ---

    // Same as iter_set_var, but for a range of entities
    iter_set_var_as_range :: proc(
        it: ^Iter,
        var_id: c.int32_t,
        range: ^TableRange,
    ) ---

    // Get value of iterator variable as entity
    iter_get_var :: proc(it: ^Iter, var_id: c.int32_t) -> Entity ---

    // Get value of iterator variable as table
    iter_get_var_as_table :: proc(it: ^Iter, var_id: c.int32_t) -> ^Table ---

    // Get value of iterator variable as table range
    iter_get_var_as_range :: proc(it: ^Iter, var_id: c.int32_t) -> TableRange ---

    // Returns whether variable is constrained
    iter_var_is_constrained :: proc(it: ^Iter, var_id: c.int32_t) -> c.bool ---

    // Create a paged iterator
    page_iter :: proc(it: ^Iter, offset: c.int32_t, limit: c.int32_t) -> Iter ---

    // Progress a paged iterator
    page_next :: proc(it: ^Iter) -> c.bool ---

    // Create a worker iterator
    worker_iter :: proc(it: ^Iter, index: c.int32_t, count: c.int32_t) -> Iter ---

    // Progress a worker iterator
    worker_next :: proc(it: ^Iter) -> c.bool ---

    // Obtain data for a query field
    field_w_size :: proc(it: ^Iter, size: size_t, index: c.int32_t) -> rawptr ---

    // Test whether the field is readonly
    field_is_readonly :: proc(it: ^Iter, index: c.int32_t) -> c.bool ---

    // Test whether the field is writeonly
    field_is_writeonly :: proc(it: ^Iter, index: c.int32_t) -> c.bool ---

    // Test whether field is set
    field_is_set :: proc(it: ^Iter, index: c.int32_t) -> c.bool ---

    // Return id matched for field
    field_id :: proc(it: ^Iter, index: c.int32_t) -> id_t ---

    // Return field source
    field_src :: proc(it: ^Iter, index: c.int32_t) -> Entity ---

    // Return field type size
    field_size :: proc(it: ^Iter, index: c.int32_t) -> size_t ---

    // Test whether the field is matched on self
    field_is_self :: proc(it: ^Iter, index: c.int32_t) -> c.bool ---

    // Convert iterator to string
    iter_str :: proc(it: ^Iter) -> cstring ---

    // Find the column index for a given id
    iter_find_column :: proc(it: ^Iter, id: id_t) -> c.int32_t ---

    // Obtain data for a column index
    iter_column_w_size :: proc(
        it: ^Iter,
        size: size_t,
        index: c.int32_t,
    ) -> rawptr ---

    // Obtain size for a column index
    iter_column_size :: proc(it: ^Iter, index: c.int32_t) -> size_t ---


    // Staging


    // Begin frame
    frame_begin :: proc(world: ^World, delta_time: ftime_t) -> ftime_t ---

    // End frame
    frame_end :: proc(world: ^World) ---

    // Begin readonly mode
    readonly_begin :: proc(world: ^World) -> c.bool ---

    // End readonly mode
    readonly_end :: proc(world: ^World) ---

    // Merge world or stage
    merge :: proc(world: ^World) ---

    // Defer operations until end of frame
    defer_begin :: proc(world: ^World) -> c.bool ---

    // Test if deferring is enabled for current stage
    is_deferred :: proc(world: ^World) -> c.bool ---

    // End block of operations to defer
    defer_end :: proc(world: ^World) -> c.bool ---

    // Suspend deferring but do not flush queue
    defer_suspend :: proc(world: ^World) ---

    // Resume deferring
    defer_resume :: proc(world: ^World) ---

    // Enable/disable automerging for world or stage
    set_automerge :: proc(world: ^World, automerge: c.bool) ---

    // Configure world to have N stages
    set_stage_count :: proc(world: ^World, stages: c.int32_t) ---

    // Get number of configured stages
    get_stage_count :: proc(world: ^World) -> c.int32_t ---

    // Get current stage id
    get_stage_id :: proc(world: ^World) -> c.int32_t ---

    // Get stage-specific world pointer
    get_stage :: proc(world: ^World, stage_id: c.int32_t) -> ^World ---

    // Get actual world from world
    get_world :: proc(world: ^poly_t) -> ^World ---

    // Test whether the current world is readonly
    stage_is_readonly :: proc(world: ^World) -> c.bool ---

    // Create asynchronous stage
    async_stage_new :: proc(world: ^World) -> ^World ---

    // Free asynchronous stage
    async_stage_free :: proc(stage: ^World) ---

    // Test whether provided stage is asynchronous
    stage_is_async :: proc(stage: ^World) -> c.bool ---

    
    // Low level functions to search for component ids in table types


    // Search for component id in table type
    search :: proc(
        world: ^World,
        table: ^Table,
        id: id_t,
        id_out: ^id_t,
    ) -> c.int32_t ---

    // Search for component id in table type starting from an offset
    search_offset :: proc(
        world: ^World,
        table: ^Table,
        offset: c.int32_t,
        id: id_t,
        id_out: ^id_t,
    ) -> c.int32_t ---

    // Search for component/relationship id in table type starting
    // from an offset
    search_relation :: proc(
        world: ^World,
        table: ^Table,
        offset: c.int32_t,
        id: id_t,
        rel: Entity,
        flags: flags32_t,
        subject_out: ^Entity,
        id_out: ^id_t,
        tr_out: [^]TableRecord,
    ) -> c.int32_t ---


    // Public table operations


    // Get type for table
    table_get_type :: proc(table: ^Table) -> ^Type ---

    // Get column from table
    table_get_column :: proc(table: ^Table, index: c.int32_t) -> rawptr ---

    // Get column index for id
    table_get_index :: proc(world: ^World, table: ^Table, id: id_t) -> c.int32_t ---

    // Get storage type for table
    table_get_storage_table :: proc(table: ^Table) -> ^Table ---

    // Convert index in table type to index in table storage type
    table_type_to_storage_index :: proc(table: ^Table, index: c.int32_t) -> c.int32_t ---

    // Convert index in table storage type to index in table type
    table_storage_to_type_index :: proc(table: ^Table, index: c.int32_t) -> c.int32_t ---

    // Returns the number of records in the table
    table_count :: proc(table: ^Table) -> c.int32_t ---

    // Get table that has all components of current table plus the
    // specified id
    table_add_id :: proc(world: ^World, table: ^Table, id: id_t) -> ^Table ---

    // Get table that has all components of current table minus the
    // specified id
    table_remove_id :: proc(world: ^World, table: ^Table, id: id_t) -> ^Table ---

    // Lock or unlock table
    table_lock :: proc(world: ^World, table: ^Table) ---

    // Unlock a table
    table_unlock :: proc(world: ^World, table: ^Table) ---

    // Returns whether table is a module or contains module contents
    table_has_module :: proc(table: ^Table) -> c.bool ---

    // Swaps two elements inside the table
    table_swap_rows :: proc(
        world: ^World,
        table: ^Table,
        row_1: c.int32_t,
        row_2: c.int32_t,
    ) ---

    // Commit (move) entity to a table
    commit :: proc(
        world: ^World,
        entity: Entity,
        record: ^Record,
        table: ^Table,
        added: ^Type,
        removed: ^Type,
    ) -> c.bool ---

    // Find record for entity
    record_find :: proc(world: ^World, entity: Entity) -> ^Record ---

    // Get component pointer from column/record
    record_get_column :: proc(r: ^Record, column: c.int32_t, c_size: size_t) -> rawptr ---


    // Values API for dynamic values


    // Construct a value in existing storage
    value_init :: proc(world: ^World, type: Entity, ptr: rawptr) -> c.int ---

    // Construct a value in existing storage with type info
    value_init_w_type_info :: proc(
        world: ^World,
        ti: ^TypeInfo,
        ptr: rawptr,
    ) -> c.int ---

    // Construct a value in new storage
    value_new :: proc(
        world: ^World,
        type: Entity,
    ) -> rawptr ---

    // Destruct a value
    value_fini_w_type_info :: proc(
        world: ^World,
        ti: ^TypeInfo,
        ptr: rawptr,
    ) -> c.int ---

    // Destruct a value
    value_fini :: proc(
        world: ^World,
        type: Entity,
        ptr: rawptr,
    ) -> c.int ---

    // Destruct a value, free storage
    value_free :: proc(
        world: ^World,
        type: Entity,
        ptr: rawptr,
    ) -> c.int ---

    // Copy value
    value_copy_w_type_info :: proc(
        world: ^World,
        ti: ^TypeInfo,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    // Copy value
    value_copy :: proc(
        world: ^World,
        type: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    // Move value
    value_move_w_type_info :: proc(
        world: ^World,
        ti: ^TypeInfo,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    // Move value
    value_move :: proc(
        world: ^World,
        type: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    // Move construct value
    value_move_ctor_w_type_info :: proc(
        world: ^World,
        ti: ^TypeInfo,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    // Move construct value
    value_move_ctor :: proc(
        world: ^World,
        type: Entity,
        dst: rawptr,
        src: rawptr,
    ) -> c.int ---

    
    // Log


    // Should current level be logged
    should_log :: proc(level: c.int32_t) -> c.bool ---

    // Get description for error code
    strerror :: proc(error_code: c.int32_t) -> cstring ---

    // Enable or disable tracing
    log_set_level :: proc(level: c.int) -> c.int ---

    // Enable/disable tracing with colors
    log_enable_colors :: proc(enabled: c.bool) -> c.bool ---

    // Enable/disable logging timestamp
    log_enable_timestamp :: proc(enabled: c.bool) -> c.bool ---

    // Enable/disable logging time since last log
    log_enable_timedelta :: proc(enabled: c.bool) -> c.bool ---

    // Get last logged error code
    log_last_error :: proc() -> c.int ---
}

@(default_calling_convention = "c", link_prefix = "flecs_")
foreign flecs
{
    allocator_init :: proc(a: ^Allocator) ---
    allocator_fini :: proc(a: ^Allocator) ---
    allocator_get :: proc(a: ^Allocator, size: size_t) -> ^BlockAllocator ---
    strdup :: proc(a: ^Allocator, str: cstring) -> ^c.char ---
    strfree :: proc(a: ^Allocator, str: cstring) ---
    dup :: proc(a: ^Allocator, size: size_t, src: rawptr) -> rawptr ---
}