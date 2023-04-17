package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "system:flecs.lib"
}

// _ Functions
@(default_calling_convention = "c", link_prefix = "_ecs", private)
foreign flecs
{
    // Map
    _map_get_deref :: proc(map_: ^Map, key: Map_Key) -> rawptr ---
}

// Public functions
@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // OS API
    os_init :: proc() ---
    os_fini :: proc() ---
    os_set_api :: proc(os_api: ^OS_API) ---
    os_get_api :: proc() -> OS_API ---
    os_set_api_defaults :: proc() ---

    // API Support
    module_path_from_c :: proc(c_name: cstring) -> cstring ---
    default_ctor :: proc(ptr: rawptr, count: i32, ctx: ^Type_Info) ---
    asprintf :: proc(fmt: cstring, #c_vararg args: ..any) -> cstring ---

    // Map
    map_params_init :: proc(params: ^Map_Params, allocator: ^Allocator) ---
    map_params_fini :: proc(params: ^Map_Params) ---
    map_init :: proc(map_: ^Map, allocator: ^Allocator) ---
    map_init_w_params :: proc(map_: ^Map, params: ^Map_Params) ---
    map_init_if :: proc(map_: ^Map, allocator: ^Allocator) ---
    map_init_w_params_if :: proc(result: ^Map, params: ^Map_Params) ---
    map_fini :: proc(map_: ^Map) ---
    map_get :: proc(map_: ^Map, key: Map_Key) -> ^Map_Val ---
    map_ensure :: proc(map_: ^Map, key: Map_Key) -> ^Map_Val ---
    map_ensure_alloc :: proc(map_: ^Map, elem_size: Size, key: Map_Key) -> rawptr ---
    map_insert :: proc(map_: ^Map, key: Map_Key, value: Map_Val) ---
    map_insert_alloc :: proc(map_: ^Map, elem_size: Size, key: Map_Key) -> rawptr ---
    map_remove :: proc(map_: ^Map, key: Map_Key) -> Map_Val ---
    map_remove_free :: proc(map_: ^Map, key: Map_Key) ---
    map_clear :: proc(map_: ^Map) ---
    map_iter :: proc(map_: ^Map) -> Map_Iter ---
    map_next :: proc(iter: ^Map_Iter) -> c.bool ---
    map_copy :: proc(dst: ^Map, src: ^Map) ---

    // Sparse
    sparse_init :: proc(sparse: ^Sparse, elem_size: Size) ---
    sparse_add :: proc(sparse: ^Sparse, elem_size: Size) -> rawptr ---
    sparse_last_id :: proc(sparse: ^Sparse) -> u64 ---
    sparse_count :: proc(sparse: ^Sparse) -> i32 ---
    sparse_get_dense :: proc(sparse: ^Sparse, elem_size: Size, index: i32) -> rawptr ---
    sparse_get :: proc(sparse: ^Sparse, elem_size: Size, id: u64) -> rawptr ---

    // StrBuf
    strbuf_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) -> c.bool ---
    strbuf_vappend :: proc(buffer: ^StrBuf, fmt: cstring, args: cstring) -> c.bool ---
    strbuf_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> c.bool ---
    strbuf_appendint :: proc(buffer: ^StrBuf, v: i64) -> c.bool ---
    strbuf_appendflt :: proc(buffer: ^StrBuf, v: c.double, nan_delim: c.char) -> c.bool ---
    strbuf_mergebuff :: proc(dst_buffer: ^StrBuf, src_buffer: ^StrBuf) -> c.bool ---
    strbuf_appendstr_zerocpy :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendstr_zerocpyn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_appendstr_zerocpy_const :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_appendstr_zerocpyn_const :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_get :: proc(buffer: ^StrBuf) -> cstring ---
    strbuf_get_small :: proc(buffer: ^StrBuf) -> cstring ---
    strbuf_reset :: proc(buffer: ^StrBuf) ---
    strbuf_list_push :: proc(buffer: ^StrBuf, list_open: cstring, separator: cstring) ---
    strbuf_list_pop :: proc(buffer: ^StrBuf, list_close: cstring) ---
    strbuf_list_next :: proc(buffer: ^StrBuf) ---
    strbuf_list_appendch :: proc(buffer: ^StrBuf, ch: c.char) -> c.bool ---
    strbuf_list_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) -> c.bool ---
    strbuf_list_appendstr :: proc(buffer: ^StrBuf, str: cstring) -> c.bool ---
    strbuf_list_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: i32) -> c.bool ---
    strbuf_written :: proc(buffer: ^StrBuf) -> i32 ---

    // Vec
    vec_init :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) -> ^Vec ---
    vec_init_if :: proc(vec: ^Vec, size: Size) ---
    vec_fini :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) ---
    vec_reset :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> ^Vec ---
    vec_clear :: proc(vec: ^Vec) ---
    vec_append :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> rawptr ---
    vec_remove :: proc(vec: ^Vec, size: Size, elem: i32) ---
    vec_remove_last :: proc(vec: ^Vec) ---
    vec_copy :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) -> Vec ---
    vec_reclaim :: proc(allocator: ^Allocator, vec: ^Vec, size: Size) ---
    vec_set_size :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_size :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_count :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_min_count_zeromem :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_set_count :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) ---
    vec_grow :: proc(allocator: ^Allocator, vec: ^Vec, size: Size, elem_count: i32) -> rawptr ---
    vec_count :: proc(vec: ^Vec) -> i32 ---
    vec_size :: proc(vec: ^Vec) -> i32 ---
    vec_get :: proc(vec: ^Vec, size: Size, index: i32) -> rawptr ---
    vec_first :: proc(vec: ^Vec) -> rawptr ---
    vec_last :: proc(vec: ^Vec, size: Size) -> rawptr ---
}

// Flecs functions
@(default_calling_convention = "c", link_prefix = "flecs_")
foreign flecs
{
    // Allocator
    allocator_init :: proc(a: ^Allocator) ---
    allocator_fini :: proc(a: ^Allocator) ---
    allocator_get :: proc(a: ^Allocator, size: Size) -> ^Block_Allocator ---
    strdup :: proc(a: ^Allocator, str: cstring) -> cstring ---
    strfree :: proc(a: ^Allocator, str: cstring) ---
    dup :: proc(a: ^Allocator, size: Size, src: rawptr) -> rawptr ---

    // Block_Allocator
    ballocator_init :: proc(ba: ^Block_Allocator, size: Size) ---
    ballocator_new :: proc(size: Size) -> ^Block_Allocator ---
    ballocator_fini :: proc(ba: ^Block_Allocator) ---
    ballocator_free :: proc(ba: ^Block_Allocator) ---
    balloc :: proc(allocator: ^Block_Allocator) -> rawptr ---
    bcalloc :: proc(allocator: ^Block_Allocator) -> rawptr ---
    bfree :: proc(allocator: ^Block_Allocator, memory: rawptr) ---
    brealloc :: proc(dst: ^Block_Allocator, src: ^Block_Allocator, memory: rawptr) -> rawptr ---
    bdup :: proc(ba: ^Block_Allocator, memory: rawptr) -> rawptr ---

    // Sparse
    sparse_set_generation :: proc(sparse: ^Sparse, id: u64) ---
}