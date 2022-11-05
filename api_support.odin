package flecs

import "core:c"

HI_COMPONENT_ID :: 256

// MAX_COMPONENT_ID not implementable

MAX_RECURSION :: 512

MAX_TOKEN_SIZE :: 256

OFFSET :: proc(o: c.uintptr_t, offset: c.uintptr_t) -> rawptr
{
    return cast(rawptr)(o + offset)
}

OFFSET_T :: proc(o: c.uintptr_t, $T: typeid) -> rawptr
{
    return OFFSET(o, size_of(T))
}

ELEM :: proc(ptr: c.uintptr_t, size: c.int32_t, index: c.int32_t) -> rawptr
{
    return OFFSET(ptr, cast(c.uintptr_t)(size * index))
}

ELEM_T :: proc(o: c.uintptr_t, $T: typeid, index: c.int32_t) -> rawptr
{
    return ELEM(o, size_of(T), index)
}