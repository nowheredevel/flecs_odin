package flecs

import "core:c"

Flags8 :: u8
Flags16 :: u16
Flags32 :: u32
Flags64 :: u64
Size :: i32

// Ignore sizeof, alignof, deprecated, and align (Use Odin's builtin procs for those)
// Ignore Max and Min, use Odin's builtin procs for those as well
// Ignore cast, use cast()

// Ignore magic numbers

/// Entity ID Macros
ROW_MASK :: uint(0x0FFFFFFF)
ROW_FLAGS_MASK :: ~ROW_MASK

// TODO: Change all generics to proper types
RECORD_TO_ROW :: proc($V) -> i32
{
    return cast(i32)(cast(i32)V & ROW_MASK)
}

RECORD_TO_ROW_FLAGS :: proc($V) -> u32
{
    return cast(u32)V & ROW_FLAGS_MASK
}

ROW_TO_RECORD :: proc($Row, $Flags) -> u32
{
    return cast(u32)(cast(u32)Row | Flags)
}

ID_FLAGS_MASK :: u64(255) << 56
ENTITY_MASK :: u64(0xFFFFFFFF)
GENERATION_MASK :: u64(0xFFFF) << 32

GENERATION :: proc(E: u64) -> u64
{
    return (E & GENERATION_MASK) >> 32
}

GENERATION_INC :: proc(E: u64) -> u64
{
    return (E & ~GENERATION_MASK) | (((0xFFFF & (GENERATION(E) + 1)) << 32))
}

COMPONENT_MASK :: ~ID_FLAGS_MASK

// Ignore HAS_ID_FLAG for now, as it uses token pasting

IS_PAIR :: proc(id: u64) -> u64
{
    return ((id) & ID_FLAGS_MASK) == PAIR
}

PAIR_FIRST :: proc(E: Entity) -> u32
{
    return Entity_Hi(E & COMPONENT_MASK)
}

PAIR_SECOND :: proc(E: Entity) -> u32
{
    return Entity_Lo(E)
}

// HAS_RELATION uses token pasting

id :: proc(world: ^World, $T: typeid) -> Entity
{
    edesc: EntityDesc
    name_c := strings.clone_to_cstring(_GetTypeName(T))
    edesc.name = name_c
    edesc.symbol = name_c
    return entity_init(world, &edesc)
}

// TODO: iter_action


/// Utilities for working with pair identifiers
// TODO: Replace generics with entities

Entity_Lo :: proc(value: Entity) -> u64
{
    return cast(u32)value
}

Entity_Hi :: proc(value: Entity) -> u64
{
    return cast(u32)(value >> 32)
}

Entity_Comb :: proc(lo: Entity, hi: Entity) -> u64
{
    return (((cast(u64)hi) << 32) + cast(u32)lo)
}

Pair :: proc(pred: Entity, obj: Entity) -> u64
{
    return PAIR | Entity_Comb(obj, pred)
}

// Ignore ecs_pair_t

Pair_First :: proc(world: ^World, pair: Entity) -> u64
{
    return get_alive(world, PAIR_FIRST(pair))
}

Pair_Second :: proc(world: ^World, pair: Entity) -> u64
{
    return get_alive(world, PAIR_SECOND(pair))
}

Pair_Relation :: Pair_First
Pair_Object :: Pair_Second

Poly_Id :: proc(world: ^World, tag: Entity) -> u64
{
    return Pair(id(world, EcsPoly), tag)
}


/// Actions that drive iteration
Iter_Action :: enum
{
    NextYield = 0, // Move onto next table, yield current
    CurYield = -1, // Stay on current table, yield
    Next = 1, // Move to next table, don't yield
}