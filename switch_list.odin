package flecs

import "core:c"

Switch_Header :: struct
{
    element: i32,
    count: i32,
}

Switch_Node :: struct
{
    next: i32,
    prev: i32,
}

Switch :: struct
{
    hdrs: Map,
    nodes: Vec,
    values: Vec,
}