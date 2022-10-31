package flecs

import "core:c"

when ODIN_OS == .Windows && ODIN_DEBUG
{
    foreign import flecs "lib/debug/flecs.dll"
} else when ODIN_OS == .Windows && !ODIN_DEBUG
{
    foreign import flecs "lib/release/flecs.dll"
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
}