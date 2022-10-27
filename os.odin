package flecs

import "core:c"

// Callbacks
os_thread_callback :: proc "c" (_: rawptr) -> rawptr

// API Init/Deinit
os_api_init :: proc "c" ()
os_api_fini :: proc "c" ()

// Memory management
os_api_malloc :: proc "c" (size: size_t) -> rawptr
os_api_realloc :: proc "c" (ptr: rawptr) -> rawptr
os_api_calloc :: proc "c" (size: size_t) -> rawptr
os_api_free :: proc "c" (ptr: rawptr)

// Strings
os_api_strdup :: proc "c" (str: cstring) -> ^c.char

// Threads
os_api_thread_new :: proc "c" (callback: os_thread_callback) -> os_thread_t
os_api_thread_join :: proc "c" (thread: os_thread_t) -> rawptr

// Atomic increment / decrement
os_api_ainc :: proc "c" (value: ^c.int32_t) -> c.int32_t
os_api_lainc :: proc "c" (value: ^c.int64_t) -> c.int64_t

// Mutex
os_api_mutex_new :: proc "c" () -> os_mutex_t
os_api_mutex_free :: proc "c" (mutex: os_mutex_t)
os_api_mutex_lock :: proc "c" (mutex: os_mutex_t)

// Condition variable
os_api_cond_new :: proc "c" () -> os_cond_t
os_api_cond_free :: proc "c" (cond: os_cond_t)
os_api_cond_signal :: proc "c" (cond: os_cond_t)
os_api_cond_broadcast :: proc "c" (cond: os_cond_t)
os_api_cond_wait :: proc "c" (cond: os_cond_t, mutex: os_mutex_t)

// Time
os_api_sleep :: proc "c" (sec: c.int32_t, nanosec: c.int32_t)
os_api_now :: proc "c" () -> c.uint64_t
os_api_get_time :: proc "c" (time_out: ^Time)

// Logging
os_api_log :: proc "c" (level: c.int32_t, file: cstring, line: c.int32_t, msg: cstring)

// Application termination
os_api_abort :: proc "c" ()

// Dynamic library loading
os_api_dlopen :: proc "c" (libname: cstring) -> os_dl_t
os_api_dlproc :: proc "c" (lib: os_dl_t, procname: cstring) -> os_proc_t
os_api_dlclose :: proc "c" (lib: os_dl_t)

// Logical module id to path
os_api_module_to_path :: proc "c" (module_id: cstring) -> ^c.char

OS_API :: struct
{
    // API Init / Deinit
    init_: os_api_init,
    fini_: os_api_fini,

    // Memory management
    malloc_: os_api_malloc,
    realloc_: os_api_realloc,
    calloc_: os_api_calloc,
    free_: os_api_free,

    // Strings
    strdup_: os_api_strdup,

    // Threads
    thread_new_: os_api_thread_new,
    thread_join_: os_api_thread_join,

    // Atomic increment / decrement
    ainc_: os_api_ainc,
    adec_: os_api_ainc,
    lainc_: os_api_lainc,
    ladec_: os_api_lainc,

    // Mutex
    mutex_new_: os_api_mutex_new,
    mutex_free_: os_api_mutex_free,
    mutex_lock_: os_api_mutex_lock,
    mutex_unlock_: os_api_mutex_lock,

    // Condition variable
    cond_new_: os_api_cond_new,
    cond_free_: os_api_cond_free,
    cond_signal_: os_api_cond_signal,
    cond_broadcast_: os_api_cond_broadcast,
    cond_wait_: os_api_cond_wait,

    // Time
    sleep_: os_api_sleep,
    now_: os_api_now,
    get_time_: os_api_get_time,

    // Logging
    log_: os_api_log,

    // Application termination
    abort_: os_api_abort,

    // Dynamic library loading
    dlopen_: os_api_dlopen,
    dlproc_: os_api_dlproc,
    dlclose_: os_api_dlclose,

    /* Overridable function that translates from a logical module id to a
     * shared library filename */
    module_to_dl_: os_api_module_to_path,

    /* Overridable function that translates from a logical module id to a
     * path that contains module-specif resources or assets */
    module_to_etc_: os_api_module_to_path,

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