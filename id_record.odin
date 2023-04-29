package flecs

import "core:c"

// Table_Record already defined

Id_Record_Elem :: struct
{
    prev: ^Id_Record,
    next: ^Id_Record,
}

Reachable_Elem :: struct
{
    tr: ^Table_Record,
    record: ^Record,
    src: Entity,
    id: Id,
}

Reachable_Cache :: struct
{
    generation: i32,
    current: i32,
    ids: Vec,
}

// Id_Record already defined