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
}