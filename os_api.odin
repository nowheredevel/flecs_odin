package flecs

import "core:c"

Time :: struct
{
    sec: u32,
    nanosec: u32,
}

// TODO: Allocation counters

/// Handle types
OS_Thread :: c.uintptr_t
OS_Cond :: c.uintptr_t
OS_Mutex :: c.uintptr_t
OS_DL :: c.uintptr_t
OS_Sock :: c.uintptr_t

// 64-bit thread id
OS_Thread_ID :: u64

// Generic function pointer type
OS_Proc :: #type proc "c" ()

// OS API Init
OS_API_Init :: #type proc "c" ()

// OS API Deinit
OS_API_Fini :: #type proc "c" ()


/// Memory management
OS_API_Malloc :: #type proc "c" (size: Size) -> rawptr
OS_API_Free :: #type proc "c" (ptr: rawptr)
OS_API_Realloc :: #type proc "c" (ptr: rawptr, size: Size) -> rawptr
OS_API_Calloc :: #type proc "c" (size: Size) -> rawptr
OS_API_Strdup :: #type proc "c" (str: cstring) -> cstring


/// Threads
OS_Thread_Callback :: #type proc "c" (_: rawptr) -> rawptr
OS_API_Thread_New :: #type proc "c" (callback: OS_Thread_Callback, param: rawptr) -> OS_Thread
OS_API_Thread_Join :: #type proc "c" (thread: OS_Thread) -> rawptr
OS_API_Thread_Self :: #type proc "c" () -> OS_Thread_ID


/// Atomic Increment/Decrement
OS_API_Ainc :: #type proc "c" (value: ^i32) -> i32
OS_API_Lainc :: #type proc "c" (value: ^i64) -> i64


/// Mutex
OS_API_Mutex_New :: #type proc "c" () -> OS_Mutex
OS_API_Mutex_Lock :: #type proc "c" (mutex: OS_Mutex)
OS_API_Mutex_Unlock :: #type proc "c" (mutex: OS_Mutex)
OS_API_Mutex_Free :: #type proc "c" (mutex: OS_Mutex)


/// Condition Variable
OS_API_Cond_New :: #type proc "c" () -> OS_Cond
OS_API_Cond_Free :: #type proc "c" (cond: OS_Cond)
OS_API_Cond_Signal :: #type proc "c" (cond: OS_Cond)
OS_API_Cond_Broadcast :: #type proc "c" (cond: OS_Cond)
OS_API_Cond_Wait :: #type proc "c" (cond: OS_Cond, mutex: OS_Mutex)
OS_API_Sleep :: #type proc "c" (sec: i32, nanosec: i32)
OS_API_Enable_High_Timer_Resolution :: #type proc "c" (enable: c.bool)
OS_API_Get_Time :: #type proc "c" (time_out: ^Time)
OS_API_Now :: #type proc "c" () -> u64


// Logging
OS_API_Log :: #type proc "c" (level: i32, file: cstring, line: i32, msg: cstring)

// Application Termination
OS_API_Abort :: #type proc "c" ()


/// Dynamic Libraries
OS_API_DLOpen :: #type proc "c" (libname: cstring) -> OS_DL
OS_API_DLProc :: #type proc "c" (lib: OS_DL, procname: cstring) -> OS_Proc
OS_API_DLClose :: #type proc "c" (lib: OS_DL)
OS_API_Module_To_Path :: #type proc "c" (module_id: cstring) -> cstring


OS_API :: struct
{
    // API Init/Deinit
    init_: OS_API_Init,
    fini_: OS_API_Fini,

    // Memory management
    malloc_: OS_API_Malloc,
    realloc_: OS_API_Realloc,
    calloc_: OS_API_Calloc,
    free_: OS_API_Free,

    // Strings
    strdup_: OS_API_Strdup,

    // Threads
    thread_new_: OS_API_Thread_New,
    thread_join_: OS_API_Thread_Join,
    thread_self_: OS_API_Thread_Self,

    // Atomic Increment/Decrement
    ainc_: OS_API_Ainc,
    adec_: OS_API_Ainc,
    lainc_: OS_API_Lainc,
    ladec_: OS_API_Lainc,

    // Mutex
    mutex_new_: OS_API_Mutex_New,
    mutex_free_: OS_API_Mutex_Free,
    mutex_lock_: OS_API_Mutex_Lock,
    mutex_unlock_: OS_API_Mutex_Unlock,

    // Condition variable
    cond_new_: OS_API_Cond_New,
    cond_free_: OS_API_Cond_Free,
    cond_signal_: OS_API_Cond_Signal,
    cond_broadcast_: OS_API_Cond_Broadcast,
    cond_wait_: OS_API_Cond_Wait,

    // Time
    sleep_: OS_API_Sleep,
    now_: OS_API_Now,
    get_time_: OS_API_Get_Time,

    // Logging
    // >0: Debug tracing (Only use in debug builds)
    // 0: Tracing
    // -2: Warning
    // -3: Error
    // -4: Fatal
    log_: OS_API_Log,

    // Application Termination
    abort_: OS_API_Abort,

    // Dynamic Library Loading
    dlopen_: OS_API_DLOpen,
    dlproc_: OS_API_DLProc,
    dlclose_: OS_API_DLClose,

    // Overridable function that translates from a logical module id to a shared library filename
    module_to_dl_: OS_API_Module_To_Path,

    // Overridable function that translates from a logical module id to a path that contains module-specif resources or assets
    module_to_etc_: OS_API_Module_To_Path,

    // Trace level
    log_level_: i32,

    // Trace indentation
    log_indent_: i32,

    // Last error code
    log_last_error_: i32,

    // Last recorded timestamp
    log_last_timestamp_: i64,

    // OS API flags
    flags_: Flags32,
}

when ODIN_OS != .WASI && ODIN_OS != .JS
{
    Global_OS_API :: OS_API {
        flags_ = cast(u32)OS_API_Flags.High_Resolution_Timer | cast(u32)OS_API_Flags.Log_With_Colors,
        log_level_ = -1, // Disable tracing by default, but log warnings/errors
    }
} else
{
    // Disable colors by default for emscripten
    Global_OS_API :: OS_API {
        flags_ = cast(u32)OS_API_Flags.High_Resolution_Timer,
        log_level_ = -1,
    }
}

OS_Malloc :: proc(size: Size) -> rawptr
{
    return Global_OS_API.malloc_(size)
}

OS_Free :: proc(ptr: rawptr)
{
    Global_OS_API.free_(ptr)
}