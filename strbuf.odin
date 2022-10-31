package flecs

import "core:c"

STRBUF_ELEMENT_SIZE :: 511
STRBUF_MAX_LIST_DEPTH :: 32

StrBufElement :: struct
{
    buffer_embedded: c.bool,
    pos: c.int32_t,
    buf: ^c.char,
    next: ^StrBufElement,
}