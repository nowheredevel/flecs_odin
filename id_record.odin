package flecs

import "core:c"

IdRecordElem :: struct
{
    prev: ^IdRecord,
    next: ^IdRecord,
}