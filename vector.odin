package flecs

import "core:c"

VECTOR_T_SIZE :: proc() -> c.int32_t
{
    return size_of(c.int32_t) + size_of(c.int32_t)
}

Vector :: struct
{
    count: c.int32_t,
    size: c.int32_t,
}

VECTOR_U :: proc(size: c.int32_t, alignment: c.int32_t) -> (c.int32_t, c.int16_t)
{
    return size, cast(c.int16_t)(max(VECTOR_T_SIZE(), alignment))
}

VECTOR_T :: proc($T: typeid) -> (c.int32_t, c.int16_t)
{
    return VECTOR_U(size_of(T), align_of(T))
}

comparator_t :: #type proc "c" (p1: rawptr, p2: rawptr)

vector_new :: proc($T: typeid, elem_count: c.int32_t) -> ^Vector
{
    return _vector_new(VECTOR_T(T), elem_count)
}

vector_new_t :: proc(size: c.int32_t, alignment: c.int32_t, elem_count: c.int32_t) -> ^Vector
{
    return _vector_new(VECTOR_U(size, alignment), elem_count)
}

vector_from_array :: proc($T: typeid, elem_count: c.int32_t, array: [^]rawptr) -> ^Vector
{
    return _vector_from_array(VECTOR_T(T), elem_count, array)
}

vector_zero :: proc(vector: ^Vector, $T: typeid)
{
    _vector_zero(vector, VECTOR_T(T))
}

vector_add :: proc(vector: ^Vector, $T: typeid) -> ^T
{
    return cast(^T)_vector_add(vector, VECTOR_T(T))
}

vector_add_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t) -> rawptr
{
    return _vector_add(vector, VECTOR_U(size, alignment))
}

vector_insert_at :: proc(vector: ^Vector, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)_vector_insert_at(vector, VECTOR_T(T), index)
}

vector_insert_at_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, index: c.int32_t) -> rawptr
{
    return _vector_insert_at(vector, VECTOR_U(size, alignment), index)
}

vector_addn :: proc(vector: ^Vector, $T: typeid, elem_count: c.int32_t) -> ^T
{
    return cast(^T)_vector_addn(vector, VECTOR_T(T), elem_count)
}

vector_addn_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, elem_count: c.int32_t) -> rawptr
{
    return _vector_addn(vector, VECTOR_U(size, alignment), elem_count)
}

vector_get :: proc(vector: ^Vector, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)_vector_get(vector, VECTOR_T(T), index)
}

vector_get_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, index: c.int32_t) -> rawptr
{
    return _vector_get(vector, VECTOR_U(size, alignment), index)
}

vector_last :: proc(vector: ^Vector, $T: typeid) -> ^T
{
    return cast(^T)_vector_last(vector, VECTOR_T(T))
}

vector_last_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t) -> rawptr
{
    return _vector_last(vector, VECTOR_U(size, alignment))
}

vector_set_min_size :: proc(vector: ^Vector, $T: typeid, size: c.int32_t) -> c.int32_t
{
    return _vector_set_min_size(vector, VECTOR_T(T), size)
}

// Set minimum count for the vector. If the current count of the vector is larger,
// the function will have no side effects.
vector_set_min_count :: proc(vector: ^Vector, $T: typeid, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_min_count(vector, VECTOR_T(T), elem_count)
}

// Set minimum count for the vector. If the current count of the vector is larger,
// the function will have no side effects.
vector_set_min_count_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_min_count(vector, VECTOR_U(size, alignment), elem_count)
}

// Remove last value, store last element in provided value.
vector_pop :: proc(vector: ^Vector, $T: typeid, value: rawptr) -> bool
{
    return _vector_pop(vector, VECTOR_T(T), value)
}

// Append element at specified index to another vector.
vector_move_index :: proc(dst: [^]Vector, src: ^Vector, $T: typeid, index: c.int32_t) -> c.int32_t
{
    return _vector_move_index(dst, src, VECTOR_T(T), index)
}

// Append element at specified index to another vector.
vector_move_index_t :: proc(dst: [^]Vector, src: ^Vector, size: c.int32_t, alignment: c.int32_t, index: c.int32_t) -> c.int32_t
{
    return _vector_move_index(dst, src, VECTOR_U(size, alignment), index)
}

// Remove element at specified index. Moves the last value to the index.
vector_remove :: proc(vector: ^Vector, $T: typeid, index: c.int32_t) -> c.int32_t
{
    return _vector_remove(vector, VECTOR_T(T), index)
}

// Remove element at specified index. Moves the last value to the index.
vector_remove_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, index: c.int32_t) -> c.int32_t
{
    return _vector_remove(vector, VECTOR_U(size, alignment), index)
}

// Shrink vector to make the size match the count.
vector_reclaim :: proc(vector: ^Vector, $T: typeid)
{
    _vector_reclaim(vector, VECTOR_T(T))
}

// Shrink vector to make the size match the count.
vector_reclaim_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t)
{
    _vector_reclaim(vector, VECTOR_U(size, alignment))
}

// Grow size of vector with provided number of elements.
vector_grow :: proc(vector: ^Vector, $T: typeid, size: c.int32_t) -> c.int32_t
{
    return _vector_grow(vector, VECTOR_T(T), size)
}

// Set allocation size of vector.
vector_set_size :: proc(vector: ^Vector, $T: typeid, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_size(vector, VECTOR_T(T), elem_count)
}

// Set allocation size of vector.
vector_set_size_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_size(vector, VECTOR_U(size, alignment), elem_count)
}

// Set count of vector. If the size of the vector is smaller than the provided
// count, the vector is resized.
vector_set_count :: proc(vector: ^Vector, $T: typeid, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_count(vector, VECTOR_T(T), elem_count)
}

// Set count of vector. If the size of the vector is smaller than the provided
// count, the vector is resized.
vector_set_count_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t, elem_count: c.int32_t) -> c.int32_t
{
    return _vector_set_count(vector, VECTOR_U(size, alignment), elem_count)
}

// Return first element of vector.
vector_first :: proc(vector: ^Vector, $T: typeid) -> ^T
{
    return cast(^T)_vector_first(vector, VECTOR_T(T))
}

// Return first element of vector.
vector_first_t :: proc(vector: ^Vector, size: c.int32_t, alignment: c.int32_t) -> rawptr
{
    return _vector_first(vector, VECTOR_U(size, alignment))
}

// Sort elements in vector.
vector_sort :: proc(vector: ^Vector, $T: typeid, compare_action: comparator_t)
{
    _vector_sort(vector, VECTOR_T(T), compare_action)
}

// Copy vectors
vector_copy :: proc(src: ^Vector, $T: typeid) -> ^Vector
{
    return _vector_copy(src, VECTOR_T(T))
}

// Copy vectors
vector_copy_t :: proc(src: ^Vector, size: c.int32_t, alignment: c.int32_t) -> ^Vector
{
    return _vector_copy(src, VECTOR_U(size, alignment))
}