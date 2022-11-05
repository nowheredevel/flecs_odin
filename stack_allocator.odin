package flecs

import "core:c"

STACK_PAGE_SIZE :: 4096

Stack :: struct
{
    first: StackPage,
    cur: ^StackPage,
}