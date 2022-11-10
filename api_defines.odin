package flecs

import "core:c"
import "core:reflect"
import "core:strings"

flags8_t :: c.uint8_t
flags16_t :: c.uint16_t
flags32_t :: c.uint32_t
flags64_t :: c.uint64_t

size_t :: c.int32_t

map_key_t :: c.uint64_t

va_list :: cstring

os_thread_t :: c.uintptr_t
os_cond_t :: c.uintptr_t
os_mutex_t :: c.uintptr_t
os_dl_t :: c.uintptr_t
os_sock_t :: c.uintptr_t

ftime_t :: c.float

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

ID_FLAGS_MASK :: u64(255) << 56
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

PAIR_FIRST :: proc(E: Entity) -> c.uint64_t
{
    return entity_t_hi(E & COMPONENT_MASK)
}

PAIR_SECOND :: proc(E: Entity) -> c.uint64_t
{
    return entity_t_lo(E)
}

// HAS_RELATION uses token pasting

entity_t_lo :: proc(Val: Entity) -> c.uint64_t
{
    return Val
}

entity_t_hi :: proc(Val: Entity) -> c.uint64_t
{
    return Val >> 32
}

entity_t_comb :: proc(Lo: Entity, Hi: Entity) -> c.uint64_t
{
    return ((Hi << 32) + Lo)
}

pair :: proc(Pred: Entity, Obj: Entity) -> c.uint64_t
{
    return (PAIR | entity_t_comb(Obj, Pred))
}

pair_first :: proc(world: ^World, pair: Entity) -> c.uint64_t
{
    return get_alive(world, PAIR_FIRST(pair))
}

pair_second :: proc(world: ^World, pair: Entity) -> c.uint64_t
{
    return get_alive(world, PAIR_SECOND(pair))
}

pair_relation :: pair_first
pair_object :: pair_second

// poly_id uses ecs_id

PAIR :: u64(1) << 63

// Create an entity from a typeid

id :: proc(world: ^World, $T: typeid) -> Entity
{
    edesc: EntityDesc
    name_c := strings.clone_to_cstring(_GetTypeName(T))
    edesc.name = name_c
    edesc.symbol = name_c
    return entity_init(world, &edesc)
}