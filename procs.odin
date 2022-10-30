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
}