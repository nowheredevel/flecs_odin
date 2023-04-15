package flecs

import "core:c"

STRBUF_INIT : StrBuf : {}
STRBUF_ELEMENT_SIZE :: 511
STRBUF_MAX_LIST_DEPTH :: 32

StrBuf_Element :: struct
{
    buffer_embedded: c.bool,
    pos: i32,
    buf: cstring,
    next: ^StrBuf_Element,
}

StrBuf_Element_Embedded :: struct
{
    super: StrBuf_Element,
    buf: [STRBUF_ELEMENT_SIZE + 1]c.char,
}

StrBuf_Element_Str :: struct
{
    super: StrBuf_Element,
    alloc_str: cstring,
}

StrBuf_List_Elem :: struct
{
    count: i32,
    separator: cstring,
}

StrBuf :: struct
{
    buf: cstring,
    max: i32,
    size: i32,
    elementCount: i32,
    firstElement: StrBuf_Element_Embedded,
    current: ^StrBuf_Element,
    list_stack: [STRBUF_MAX_LIST_DEPTH]StrBuf_List_Elem,
    list_sp: i32,
    content: cstring,
    length: i32,
}

strbuf_appendlit :: proc(buffer: ^StrBuf, str: cstring) -> c.bool
{
    return strbuf_appendstrn(buffer, str, cast(i32)(size_of(str) - 1))
}

strbuf_list_appendlit :: proc(buffer: ^StrBuf, str: cstring) -> c.bool
{
    return strbuf_list_appendstrn(buffer, str, cast(i32)(size_of(str) - 1))
}