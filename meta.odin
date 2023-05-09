package flecs

import "core:c"

MEMBER_DESC_CACHE_SIZE :: 32

Type_Kind :: enum
{
    Primitive_Type,
    Bitmask_Type,
    Enum_Type,
    Struct_Type,
    Array_Type,
    Vector_Type,
    Opaque_Type,
    Type_Kind_Last = Vector_Type,
}

Ecs_Meta_Type :: struct
{
    kind: Type_Kind,
    existing: c.bool,
    partial: c.bool,
    size: Size,
    alignment: Size,
}

Primitive_Kind :: enum
{
    Bool = 1,
    Char,
    Byte,
    U8,
    U16,
    U32,
    U64,
    I8,
    I16,
    I32,
    I64,
    F32,
    F64,
    UPtr,
    IPtr,
    String,
    Entity,
    Primitive_Kind_Last = Entity,
}

Ecs_Primitive :: struct
{
    kind: Primitive_Kind,
}

Ecs_Member :: struct
{
    type_: Entity,
    count: i32,
    unit: Entity,
    offset: i32,
}

Member :: struct
{
    name: cstring,
    type_: Entity,
    count: i32,
    offset: i32,
    unit: Entity,
    size: Size,
    member: Entity,
}

Ecs_Struct :: struct
{
    members: Vec,
}

Enum_Constant :: struct
{
    name: cstring,
    value: i32,
    constant: Entity,
}

Ecs_Enum :: struct
{
    constants: Map,
}

Bitmask_Constant :: struct
{
    name: cstring,
    value: Flags32,
    constant: Entity,
}

Ecs_Bitmask :: struct
{
    constants: Map,
}

Ecs_Array :: struct
{
    type_: Entity,
    count: i32,
}

Ecs_Vector :: struct
{
    type_: Entity,
}

Serializer :: struct
{
    value: proc "c" (ser: ^Serializer, type_: Entity, value: rawptr) -> c.int,
    member: proc "c" (ser: ^Serializer, member: cstring) -> c.int,
    world: ^World,
    ctx: rawptr,
}

Meta_Serialize :: #type proc "c" (ser: ^Serializer, src: rawptr) -> c.int

Ecs_Opaque :: struct
{
    as_type: Entity,
    serialize: Meta_Serialize,
    assign_bool: proc "c" (dst: rawptr, value: c.bool),
    assign_char: proc "c" (dst: rawptr, value: c.char),
    assign_int: proc "c" (dst: rawptr, value: i64),
    assign_uint: proc "c" (dst: rawptr, value: u64),
    assign_float: proc "c" (dst: rawptr, value: f64),
    assign_string: proc "c" (dst: rawptr, value: cstring),
    assign_entity: proc "c" (dst: rawptr, world: ^World, entity: Entity),
    assign_null: proc "c" (dst: rawptr),
    clear: proc "c" (dst: rawptr),
    ensure_element: proc "c" (dst: rawptr, elem: Size) -> rawptr,
    ensure_member: proc "c" (dst: rawptr, member: cstring) -> rawptr,
    count: proc "c" (dst: rawptr) -> Size,
    resize: proc "c" (dst: rawptr, count: Size),
}

Unit_Translation :: struct
{
    factor: i32,
    power: i32,
}

Ecs_Unit :: struct
{
    symbol: cstring,
    prefix: Entity,
    base: Entity,
    over: Entity,
    translation: Unit_Translation,
}

Ecs_Unit_Prefix :: struct
{
    symbol: cstring,
    translation: Unit_Translation,
}

Meta_Type_Op_Kind :: enum
{
    Array,
    Vector,
    Opaque,
    Push,
    Pop,
    Scope,
    Enum,
    Bitmask,
    Primitive,
    Bool,
    Char,
    Byte,
    U8,
    U16,
    U32,
    U64,
    I8,
    I16,
    I32,
    I64,
    F32,
    F64,
    UPtr,
    IPtr,
    String,
    Entity,
    Meta_Type_Op_Kind_Last = Entity,
}

Meta_Type_Op :: struct
{
    kind: Meta_Type_Op_Kind,
    offset: Size,
    count: i32,
    name: cstring,
    op_count: i32,
    size: Size,
    type_: Entity,
    unit: Entity,
    members: ^HashMap,
}

Ecs_Meta_Type_Serialized :: struct
{
    ops: Vec,
}

META_MAX_SCOPE_DEPTH :: 32

Meta_Scope :: struct
{
    type_: Entity,
    ops: [^]Meta_Type_Op,
    op_count: i32,
    op_cur: i32,
    elem_cur: i32,
    prev_depth: i32,
    ptr: rawptr,

    comp: ^Ecs_Component,
    opaque: ^Ecs_Opaque,
    vector: ^Vec,
    members: ^HashMap,
    is_collection: c.bool,
    is_inline_array: c.bool,
    is_empty_scope: c.bool,
}

Meta_Cursor :: struct
{
    world: ^World,
    scope: [META_MAX_SCOPE_DEPTH]Meta_Scope,
    depth: i32,
    valid: c.bool,
    is_primitive_scope: c.bool,

    lookup_action: proc "c" (_: ^World, _: cstring, _: rawptr) -> Entity,
    lookup_ctx: rawptr,
}

Primitive_Desc :: struct
{
    entity: Entity,
    kind: Primitive_Kind,
}

Enum_Desc :: struct
{
    entity: Entity,
    constants: [MEMBER_DESC_CACHE_SIZE]Enum_Constant,
}

Bitmask_Desc :: struct
{
    entity: Entity,
    constants: [MEMBER_DESC_CACHE_SIZE]Bitmask_Constant,
}

Array_Desc :: struct
{
    entity: Entity,
    type_: Entity,
    count: i32,
}

Vector_Desc :: struct
{
    entity: Entity,
    type_: Entity,
}

Struct_Desc :: struct
{
    entity: Entity,
    members: [MEMBER_DESC_CACHE_SIZE]Member,
}

Opaque_Desc :: struct
{
    entity: Entity,
    type_: Ecs_Opaque,
}

Unit_Desc :: struct
{
    entity: Entity,
    symbol: cstring,
    quantity: Entity,
    base: Entity,
    over: Entity,
    translation: Unit_Translation,
    prefix: Entity,
}

Unit_Prefix_Desc :: struct
{
    entity: Entity,
    symbol: cstring,
    translation: Unit_Translation,
}

// Ignore convenience macros, they're unimplementable