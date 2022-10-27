package flecs

when ODIN_OS == .Windows
{
    foreign import flecs "lib/flecs_static.lib"
}

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // OS
    os_init :: proc() ---
    os_fini :: proc() ---
    os_set_api :: proc(os_api: ^OS_API) ---
    os_get_api :: proc() -> OS_API ---
    os_set_api_defaults :: proc() ---
}