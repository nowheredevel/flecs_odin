package flecs

import "core:c"

STRBUF_INIT :: proc() -> StrBuf
{
    return {}
}

STRBUF_ELEMENT_SIZE :: 511
STRBUF_MAX_LIST_DEPTH :: 32

StrBufElement :: struct
{
    buffer_embedded: c.bool,
    pos: c.int32_t,
    buf: cstring,
    next: ^StrBufElement,
}

StrBufElementEmbedded :: struct
{
    super: StrBufElement,
    buf: [STRBUF_ELEMENT_SIZE + 1]c.char,
}

StrBufElementStr :: struct
{
    super: StrBufElement,
    alloc_str: cstring,
}

StrBufListElem :: struct
{
    count: c.int32_t,
    separator: cstring,
}

StrBuf :: struct
{
    buf: cstring,
    max: c.int32_t,
    size: c.int32_t,
    elementCount: c.int32_t,
    firstElement: StrBufElementEmbedded,
    current: ^StrBufElement,
    list_stack: [STRBUF_MAX_LIST_DEPTH]StrBufListElem,
    list_sp: c.int32_t,
    content: cstring,
    length: c.int32_t,
}

strbuf_appendlit :: proc(buf: ^StrBuf, str: cstring) -> bool
{
    return strbuf_appendstrn(buf, str, cast(c.int32_t)(size_of(str) - 1))
}

strbuf_list_appendlit :: proc(buf: ^StrBuf, str: cstring) -> bool
{
    return strbuf_list_appendstrn(buf, str, cast(c.int32_t)(size_of(str) - 1))
}