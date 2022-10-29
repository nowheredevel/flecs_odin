package flecs

when ODIN_OS == .Windows && ODIN_DEBUG
{
    foreign import flecs "lib/debug/flecs.dll"
} else when ODIN_OS == .Windows && !ODIN_DEBUG
{
    foreign import flecs "lib/release/flecs.dll"
}

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{

}