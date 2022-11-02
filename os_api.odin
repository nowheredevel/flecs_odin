package flecs

import "core:c"
import "core:mem"

Time :: struct
{
    sec: c.uint32_t,
    nanosec: c.uint32_t,
}

// OS API callbacks

// Generic function pointer type
os_proc_t :: #type proc "c" ()

// OS API init & deinit
os_api_init_t :: #type proc "c" ()
os_api_fini_t :: #type proc "c" ()

// Memory management
os_api_malloc_t :: #type proc "c" (size: size_t) -> rawptr
os_api_free_t :: #type proc "c" (ptr: rawptr)
os_api_realloc_t :: #type proc "c" (ptr: rawptr, size: size_t) -> rawptr
os_api_calloc_t :: #type proc "c" (size: size_t) -> rawptr
os_api_strdup_t :: #type proc "c" (str: cstring) -> cstring

// Threads
os_thread_callback_t :: #type proc "c" (_: rawptr) -> rawptr
os_api_thread_new_t :: #type proc "c" (callback: os_thread_callback_t, param: rawptr) -> os_thread_t
os_api_thread_join_t :: #type proc "c" (thread: os_thread_t) -> rawptr

// Atomic increment/decrement
os_api_ainc_t :: #type proc "c" (value: ^c.int32_t) -> c.int32_t
os_api_lainc_t :: #type proc "c" (value: ^c.int64_t) -> c.int64_t

// Mutex
os_api_mutex_new_t :: #type proc "c" () -> os_mutex_t
os_api_mutex_lock_t :: #type proc "c" (mutex: os_mutex_t)
os_api_mutex_unlock_t :: #type proc "c" (mutex: os_mutex_t)
os_api_mutex_free_t :: #type proc "c" (mutex: os_mutex_t)

// Condition variable
os_api_cond_new_t :: #type proc "c" () -> os_cond_t
os_api_cond_free_t :: #type proc "c" (cond: os_cond_t)
os_api_cond_signal_t :: #type proc "c" (cond: os_cond_t)
os_api_cond_broadcast_t :: #type proc "c" (cond: os_cond_t)
os_api_cond_wait_t :: #type proc "c" (cond: os_cond_t, mutex: os_mutex_t)
os_api_sleep_t :: #type proc "c" (sec: c.int32_t, nanosec: c.int32_t)
os_api_enable_high_timer_resolution_t :: #type proc "c" (enable: bool)
os_api_get_time_t :: #type proc "c" (time_out: ^Time)
os_api_now_t :: #type proc "c" () -> c.uint64_t

// Logging
os_api_log_t :: #type proc "c" (level: c.int32_t, file: cstring, line: c.int32_t, msg: cstring)

// Application termination
os_api_abort_t :: #type proc "c" ()

// Dynamic libraries
os_api_dlopen_t :: #type proc "c" (libname: cstring) -> os_dl_t
os_api_dlproc_t :: #type proc "c" (lib: os_dl_t, procname: cstring) -> os_proc_t
os_api_dlclose_t :: #type proc "c" (lib: os_dl_t)
os_api_module_to_path_t :: #type proc "c" (module_id: cstring) -> cstring

when ODIN_OS != .WASI || ODIN_OS != .JS
{
    GlobalOSApi :: OSApi {
        flags_ = cast(u32)OSApiFlags.HighResolutionTimer | cast(u32)OSApiFlags.LogWithColors,
        log_level_ = -1, // Disable tracing by default, but log warnings/errors
    }
} else
{
    // Disable colors by default for emscripten
    GlobalOSApi :: OSApi {
        flags_ = cast(u32)OSApiFlags.HighResolutionTimer,
        log_level_ = -1,
    }
}

OSApi :: struct
{
    // API init/deinit
    init_: os_api_init_t,
    fini_: os_api_fini_t,

    // Memory management
    malloc_: os_api_malloc_t,
    realloc_: os_api_realloc_t,
    calloc_: os_api_calloc_t,
    free_: os_api_free_t,

    // Strings
    strdup_: os_api_strdup_t,

    // Threads
    thread_new_: os_api_thread_new_t,
    thread_join_: os_api_thread_join_t,

    // Atomic increment/decrement
    ainc_: os_api_ainc_t,
    adec_: os_api_ainc_t,
    lainc_: os_api_lainc_t,
    ladec_: os_api_lainc_t,

    // Mutex
    mutex_new_: os_api_mutex_new_t,
    mutex_free_: os_api_mutex_free_t,
    mutex_lock_: os_api_mutex_lock_t,
    mutex_unlock_: os_api_mutex_lock_t,

    // Condition variable
    cond_new_: os_api_cond_new_t,
    cond_free_: os_api_cond_free_t,
    cond_signal_: os_api_cond_signal_t,
    cond_broadcast_: os_api_cond_broadcast_t,
    cond_wait_: os_api_cond_wait_t,

    // Time
    sleep_: os_api_sleep_t,
    now_: os_api_now_t,
    get_time_: os_api_get_time_t,

    // Logging
    log_: os_api_log_t,

    // Application termination
    abort_: os_api_abort_t,

    // Dynamic library loading
    dlopen_: os_api_dlopen_t,
    dlproc_: os_api_dlproc_t,
    dlclose_: os_api_dlclose_t,

    // Translates logical module id to shared lib filename
    module_to_dl_: os_api_module_to_path_t,

    // Translates logical module id to path w/ module-specific resources
    // or assets
    module_to_etc_: os_api_module_to_path_t,

    // Trace level
    log_level_: c.int32_t,

    // Trace indentation
    log_indent_: c.int32_t,

    // Last error code
    log_last_error_: c.int32_t,

    // Last recorded timestamp
    log_last_timestamp_: c.int64_t,

    // OS API flags
    flags_: flags32_t,
}

os_malloc :: proc(size: size_t) -> rawptr
{
    return GlobalOSApi.malloc_(size)
}

os_free :: proc(ptr: rawptr)
{
    GlobalOSApi.free_(ptr)
}

os_realloc :: proc(ptr: rawptr, size: size_t) -> rawptr
{
    return GlobalOSApi.realloc_(ptr, size)
}

os_calloc :: proc(size: size_t) -> rawptr
{
    return GlobalOSApi.calloc_(size)
}

os_alloca :: proc(size: size_t) -> rawptr
{
    return mem.alloc(cast(int)size)
}

os_malloc_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_malloc(size_of(T))
}

os_malloc_n :: proc($T: typeid, count: u32) -> ^T
{
    return cast(^T)os_malloc(size_of(T) * count)
}

os_calloc_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_calloc(size_of(T))
}

os_calloc_n :: proc($T: typeid, count: u32) -> ^T
{
    return cast(^T)os_calloc(size_of(T) * count)
}

os_realloc_t :: proc(ptr: rawptr, $T: typeid) -> ^T
{
    return cast(^T)os_realloc(ptr, size_of(T))
}

os_realloc_n :: proc(ptr: rawptr, $T: typeid, count: u32) -> ^T
{
    return cast(^T)os_realloc(ptr, size_of(T) * count)
}

os_alloca_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_alloca(size_of(T))
}

os_alloca_n :: proc($T: typeid, count: u32) -> ^T
{
    return cast(^T)os_alloca(size_of(T) * count)
}

// Strings