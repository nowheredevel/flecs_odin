package flecs

import "core:c"

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

OSApi :: struct
{
    // API init/deinit
}