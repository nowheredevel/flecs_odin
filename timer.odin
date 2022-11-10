package flecs

import "core:c"

EcsTimer :: struct
{
    timeout: ftime_t,
    time: ftime_t,
    fired_count: c.int32_t,
    active: c.bool,
    single_shot: c.bool,
}

EcsRateFilter :: struct
{
    src: Entity,
    rate: c.int32_t,
    tick_count: c.int32_t,
    time_elapsed: ftime_t,
}