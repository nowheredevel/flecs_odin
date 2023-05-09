package flecs

import "core:c"

// Ignore convenience macro

Var_Id :: u8
Rule_Lbl :: i16
Write_Flags :: Flags64

Rule_Max_Var_Count :: 64
Var_None : Var_Id : 255
This_Name : cstring : "this"

Var_Kind :: enum
{
    Entity,
    Table,
    Any,
}

Rule_Var :: struct
{
    kind: i8,
    id: Var_Id,
    table_id: Var_Id,
    name: cstring,
}

Rule_Op_Kind :: enum
{
    And,
    And_Id,
    With,
    And_Any,
    Trav,
    Ids_Right,
    Ids_Left,
    Each,
    Store,
    Union,
    End,
    Not,
    Pred_Eq,
    Pred_Neq,
    Pred_Eq_Name,
    Pred_Neq_Name,
    Pred_Eq_Match,
    Pred_Neq_Match,
    Set_Vars,
    Set_This,
    Set_Fixed,
    Set_Ids,
    Contain,
    Pair_Eq,
    Set_Cond,
    Jmp_Cond_False,
    Jmp_Not_Set,
    Yield,
    Nothing,
}

Rule_Is_Entity :: 1 << 0
Rule_Is_Var :: 1 << 1
Rule_Is_Self :: 1 << 6

Rule_Src :: 0
Rule_First :: 2
Rule_Second :: 4

Rule_Ref :: struct #raw_union
{
    var: Var_Id,
    entity: Entity,
}

Rule_Op :: struct
{
    kind: u8,
    flags: Flags8,
    field_index: i8,
    term_index: i8,
    prev: Rule_Lbl,
    next: Rule_Lbl,
    other: Rule_Lbl,
    match_flags: Flags16,
    src: Rule_Ref,
    first: Rule_Ref,
    second: Rule_Ref,
    written: Flags64,
}

Rule_And_Ctx :: struct
{
    idr: ^Id_Record,
    it: Table_Cache_Iter,
    column: i16,
    remaining: i16,
}

Trav_Elem :: struct
{
    entity: Entity,
    idr: ^Id_Record,
    column: i32,
}

Trav_Cache :: struct
{
    id: Id,
    idr: ^Id_Record,
    entities: Vec,
    up: c.bool,
}

Rule_Trav_Ctx :: struct
{
    and: Rule_And_Ctx,
    index: i32,
    offset: i32,
    count: i32,
    cache: ^Trav_Cache,
    yield_reflexive: c.bool,
}

Rule_Eq_Ctx :: struct
{
    range: Table_Range,
    index: i32,
    name_col: i16,
    redo: c.bool,
}

Rule_Each_Ctx :: struct
{
    row: i32,
}

Rule_SetThis_Ctx :: struct
{
    range: Table_Range,
}

Rule_Ids_Ctx :: struct
{
    cur: ^Id_Record,
}

Rule_CtrlFlow_Ctx :: struct
{
    lbl: Rule_Lbl,
}

Rule_Cond_Ctx :: struct
{
    cond: c.bool,
}

Rule_Op_Ctx :: struct
{
    is: struct #raw_union
    {
        and: Rule_And_Ctx,
        trav: Rule_Trav_Ctx,
        ids: Rule_Ids_Ctx,
        eq: Rule_Eq_Ctx,
        each: Rule_Each_Ctx,
        setthis: Rule_SetThis_Ctx,
        ctrlflow: Rule_CtrlFlow_Ctx,
        cond: Rule_Cond_Ctx,
    },
}

Rule_Compile_Ctx :: struct
{
    ops: ^Vec,
    written: Write_Flags,
    cond_written: Write_Flags,

    lbl_union: Rule_Lbl,
    lbl_not: Rule_Lbl,
    lbl_option: Rule_Lbl,
    lbl_cond_eval: Rule_Lbl,
    lbl_or: Rule_Lbl,
    lbl_none: Rule_Lbl,
    lbl_prev: Rule_Lbl,
}

Rule_Run_Ctx :: struct
{
    written: [^]u64,
    op_index: Rule_Lbl,
    prev_index: Rule_Lbl,
    jump: Rule_Lbl,
    vars: [^]Var,
    it: ^Iter,
    op_ctx: ^Rule_Op_Ctx,
    world: ^World,
    rule: ^Rule,
    rule_vars: [^]Rule_Var,
}

Rule_Var_Cache :: struct
{
    var: Rule_Var,
    name: cstring,
}