package flecs

import "core:c"

STACK_PAGE_SIZE :: 4096

// Stack_Page already defined

Stack :: struct
{
    first: Stack_Page,
    cur: ^Stack_Page,
}