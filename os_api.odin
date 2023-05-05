package flecs

import "core:c"
import "core:c/libc"
import "core:mem"

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
OS_Thread_Id :: u64

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
OS_API_Thread_Self :: #type proc "c" () -> OS_Thread_Id


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

os_malloc :: proc(size: Size) -> rawptr
{
    return Global_OS_API.malloc_(size)
}

os_free :: proc(ptr: rawptr)
{
    Global_OS_API.free_(ptr)
}

os_realloc :: proc(ptr: rawptr, size: Size) -> rawptr
{
    return Global_OS_API.realloc_(ptr, size)
}

os_calloc :: proc(size: Size) -> rawptr
{
    return Global_OS_API.calloc_(size)
}

os_alloca :: proc(size: Size) -> rawptr
{
    return mem.alloc(cast(int)size)
}

os_malloc_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_malloc(size_of(T))
}

os_malloc_n :: proc($T: typeid, count: Size) -> [^]T
{
    return cast([^]T)os_malloc(size_of(T) * count)
}

os_calloc_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_calloc(size_of(T))
}

os_calloc_n :: proc($T: typeid, count: Size) -> [^]T
{
    return cast([^]T)os_calloc(size_of(T) * count)
}

os_realloc_t :: proc(ptr: rawptr, $T: typeid) -> ^T
{
    return cast(^T)os_realloc(ptr, size_of(T))
}

os_realloc_n :: proc(ptr: rawptr, $T: typeid, count: Size) -> [^]T
{
    return cast([^]T)os_realloc(ptr, size_of(T) * count)
}

os_alloca_t :: proc($T: typeid) -> ^T
{
    return cast(^T)os_alloca(size_of(T))
}

os_alloca_n :: proc($T: typeid, count: i32) -> [^]T
{
    return cast([^]T)os_alloca(size_of(T) * count)
}

os_strdup :: proc(str: cstring) -> cstring
{
    return Global_OS_API.strdup_(str)
}

os_strlen :: proc(str: cstring) -> uint
{
    return libc.strlen(str)
}

os_strncmp :: proc(str1: cstring, str2: cstring, num: uint) -> c.int
{
    return libc.strncmp(str1, str2, num)
}

os_memcmp :: proc(ptr1: rawptr, ptr2: rawptr, num: uint) -> c.int
{
    return libc.memcmp(ptr1, ptr1, num)
}

os_memcpy :: proc(ptr1: rawptr, ptr2: rawptr, num: uint) -> rawptr
{
    return libc.memcpy(ptr1, ptr2, num)
}

os_memset :: proc(ptr: rawptr, value: c.int, num: uint) -> rawptr
{
    return libc.memset(ptr, value, num)
}

os_memmove :: proc(dst: rawptr, src: rawptr, size: uint) -> rawptr
{
    return libc.memmove(dst, src, size)
}

os_memcpy_t :: proc(ptr1: rawptr, ptr2: rawptr, $T: typeid) -> rawptr
{
    return os_memcpy(ptr1, ptr2, size_of(T))
}

os_memcpy_n :: proc(ptr1: rawptr, ptr2: rawptr, $T: typeid, count: i32) -> rawptr
{
    return os_memcpy(ptr1, ptr2, size_of(T) * count)
}

os_memcmp_t :: proc(ptr1: rawptr, ptr2: rawptr, $T: typeid) -> c.int
{
    return os_memcmp(ptr1, ptr2, size_of(T))
}

os_strcmp :: proc(str1: cstring, str2: cstring) -> c.int
{
    return libc.strcmp(str1, str2)
}

os_memset_t :: proc(ptr: rawptr, value: c.int, $T: typeid) -> rawptr
{
    return os_memset(ptr, value, size_of(T))
}

os_memset_n :: proc(ptr: rawptr, value: c.int, $T: typeid, count: i32) -> rawptr
{
    return os_memset(ptr, value, size_of(T) * count)
}

os_zeromem :: proc(ptr: rawptr) -> rawptr
{
    return os_memset(ptr, 0, size_of(ptr))
}

os_memdup_t :: proc(ptr: rawptr, $T: typeid) -> rawptr
{
    return os_memdup(ptr, size_of(T))
}

os_memdup_n :: proc(ptr: rawptr, $T: typeid, count: i32) -> rawptr
{
    return os_memdup(ptr, size_of(T) * count)
}

offset :: proc(ptr: rawptr, $T: typeid, index: i32) -> ^T
{
    return cast(^T)offset_of(ptr, size_of(T) * index)
}

os_strcat :: proc(str1: [^]c.char, str2: cstring) -> [^]c.char
{
    return libc.strcat(str1, str2)
}

os_sprintf :: proc(ptr: [^]c.char, format: cstring, args: ..any) -> c.int
{
    return libc.snprintf(ptr, format, args)
}

os_vsprintf :: proc(ptr: [^]c.char, fmt: cstring, args: ^libc.va_list) -> c.int
{
    return libc.vsprintf(ptr, fmt, args)
}

os_strcpy :: proc(str1: [^]c.char, str2: cstring) -> [^]c.char
{
    return libc.strcpy(str1, str2)
}

os_strncpy :: proc(str1: [^]c.char, str2: cstring, num: uint) -> [^]c.char
{
    return libc.strncpy(str1, str2, num)
}

os_fopen :: proc(result: ^libc.FILE, file: cstring, mode: cstring)
{
    result := result
    result = libc.fopen(file, mode)
}

/// Threads

os_thread_new :: proc(callback: OS_Thread_Callback, param: rawptr) -> OS_Thread
{
    return Global_OS_API.thread_new_(callback, param)
}

os_thread_join :: proc(thread: OS_Thread) -> rawptr
{
    return Global_OS_API.thread_join_(thread)
}

os_thread_self :: proc() -> OS_Thread_Id
{
    return Global_OS_API.thread_self_()
}

/// Atomic increment/decrement

os_ainc :: proc(value: ^i32) -> i32
{
    return Global_OS_API.ainc_(value)
}

os_adec :: proc(value: ^i32) -> i32
{
    return Global_OS_API.adec_(value)
}

os_lainc :: proc(value: ^i64) -> i64
{
    return Global_OS_API.lainc_(value)
}

os_ladec :: proc(value: ^i64) -> i64
{
    return Global_OS_API.ladec_(value)
}

/// Mutex

os_mutex_new :: proc() -> OS_Mutex
{
    return Global_OS_API.mutex_new_()
}

os_mutex_free :: proc(mutex: OS_Mutex)
{
    Global_OS_API.mutex_free_(mutex)
}

os_mutex_lock :: proc(mutex: OS_Mutex)
{
    Global_OS_API.mutex_lock_(mutex)
}

os_mutex_unlock :: proc(mutex: OS_Mutex)
{
    Global_OS_API.mutex_unlock_(mutex)
}

/// Condition variable

os_cond_new :: proc() -> OS_Cond
{
    return Global_OS_API.cond_new_()
}

os_cond_free :: proc(cond: OS_Cond)
{
    Global_OS_API.cond_free_(cond)
}

os_cond_signal :: proc(cond: OS_Cond)
{
    Global_OS_API.cond_signal_(cond)
}

os_cond_broadcast :: proc(cond: OS_Cond)
{
    Global_OS_API.cond_broadcast_(cond)
}

os_cond_wait :: proc(cond: OS_Cond, mutex: OS_Mutex)
{
    Global_OS_API.cond_wait_(cond, mutex)
}

/// Time

os_sleep :: proc(sec: i32, nanosec: i32)
{
    Global_OS_API.sleep_(sec, nanosec)
}

os_now :: proc() -> u64
{
    return Global_OS_API.now_()
}

os_get_time :: proc(time_out: ^Time)
{
    Global_OS_API.get_time_(time_out)
}

os_inc :: proc(v: ^i32) -> i32
{
    return os_ainc(v)
}

os_linc :: proc(v: ^i64) -> i64
{
    return os_lainc(v)
}

os_dec :: proc(v: ^i32) -> i32
{
    return os_adec(v)
}

os_ldec :: proc(v: ^i64) -> i64
{
    return os_ladec(v)
}

os_abort :: proc()
{
    Global_OS_API.abort_()
}

os_dlopen :: proc(libname: cstring) -> OS_DL
{
    return Global_OS_API.dlopen_(libname)
}

os_dlproc :: proc(lib: OS_DL, procname: cstring) -> OS_Proc
{
    return Global_OS_API.dlproc_(lib, procname)
}

os_dlclose :: proc(lib: OS_DL)
{
    Global_OS_API.dlclose_(lib)
}

os_module_to_dl :: proc(lib: cstring) -> cstring
{
    return Global_OS_API.module_to_dl_(lib)
}

os_module_to_etc :: proc(lib: cstring) -> cstring
{
    return Global_OS_API.module_to_etc_(lib)
}