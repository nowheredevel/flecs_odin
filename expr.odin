package flecs

import "core:c"

Expr_Var :: struct
{
    name: cstring,
    value: Value,
    owned: c.bool,
}

Expr_Var_Scope :: struct
{
    var_index: HashMap,
    vars: Vec,
    parent: ^Expr_Var_Scope,
}

Vars :: struct
{
    world: ^World,
    root: Expr_Var_Scope,
    cur: ^Expr_Var_Scope,
}

Parse_Expr_Desc :: struct
{
    name: cstring,
    expr: cstring,
    lookup_action: proc "c" (_: ^World, value: cstring, ctx: rawptr) -> Entity,
    lookup_ctx: rawptr,
    vars: ^Vars,
}