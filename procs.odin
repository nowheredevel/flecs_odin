package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "flecs.dll"
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