package flecs

import "core:c"
import "core:reflect"

ROW_MASK :: uint(0x0FFFFFFF)
ROW_FLAGS_MASK :: ~ROW_MASK

// TODO: Change all generics to actual types
RECORD_TO_ROW :: proc($V) -> c.int32_t
{
    return cast(c.int32_t)(cast(c.int32_t)V & ROW_MASK)
}

RECORD_TO_ROW_FLAGS :: proc($V) -> c.uint32_t
{
    return cast(c.uint32_t)V & ROW_FLAGS_MASK
}

ROW_TO_RECORD :: proc($Row, $Flags) -> c.uint32_t
{
    return cast(c.uint32_t)(cast(c.uint32_t)Row | (Flags))
}

ID_FLAGS_MASK :: u128(0xFF) << 60
ENTITY_MASK :: u64(0xFFFFFFFF)
GENERATION_MASK :: u64(0xFFFF) << 32

GENERATION :: proc($E) -> u64
{
    return ((E & GENERATION_MASK) >> 32)
}

GENERATION_INC :: proc($E) -> u64
{
    return ((E & ~GENERATION_MASK) | ((0xFFFF & (GENERATION(E) + 1)) << 32))
}

COMPONENT_MASK :: ~ID_FLAGS_MASK

// HAS_ID_FLAG uses token pasting


IS_PAIR :: proc($ID) -> bool
{
    return ((ID) & ID_FLAGS_MASK) == PAIR
}

PAIR_FIRST :: proc($E) -> c.uint32_t
{
    return entity_t_hi(E & COMPONENT_MASK)
}

PAIR_SECOND :: proc($E) -> c.uint32_t
{
    return entity_t_lo(E)
}

// HAS_RELATION uses token pasting


entity_t_lo :: proc($Value) -> c.uint32_t
{
    return cast(c.uint32_t)Value
}

entity_t_hi :: proc($Value) -> c.uint32_t
{
    return cast(c.uint32_t)(Value >> 32)
}

entity_t_comb :: proc($Lo, $Hi) -> c.uint64_t
{
    return ((cast(c.uint64_t)Hi << 32) + cast(c.uint32_t)Lo)
}

pair :: proc($Pred, $Obj) -> c.uint64_t
{
    return (PAIR | entity_t_comb(Obj, Pred))
}

pair_first :: proc($World, $Pair)
{
    // TODO: return get_alive(World, PAIR_FIRST(Pair))
}

pair_second :: proc($World, $Pair)
{
    // TODO: return get_alive(World, PAIR_SECOND(Pair))
}

pair_relation :: pair_first
pair_object :: pair_second

// poly_id uses ecs_id

PAIR :: u64(1) << 63