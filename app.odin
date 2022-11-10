package flecs

import "core:c"

app_init_action_t :: #type proc "c" (world: ^World) -> c.int

AppDesc :: struct
{
    target_fps: ftime_t,
    delta_time: ftime_t,
    threads: c.int32_t,
    frames: c.int32_t,
    enable_rest: c.bool,
    enable_monitor: c.bool,

    init: app_init_action_t,

    ctx: rawptr,
}

app_run_action_t :: #type proc "c" (world: ^World, desc: ^AppDesc) -> c.int
app_frame_action_t :: #type proc "c" (world: ^World, desc: ^AppDesc) -> c.int

