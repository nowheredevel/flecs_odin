package flecs

import "core:c"

App_Init_Action :: #type proc "c" (world: ^World) -> c.int

App_Desc :: struct
{
    target_fps: FTime,
    delta_time: FTime,
    threads: i32,
    frames: i32,
    enable_rest: c.bool,
    enable_monitor: c.bool,
    init: App_Init_Action,
    ctx: rawptr,
}