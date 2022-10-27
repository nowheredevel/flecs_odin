package flecs

import "core:c"

@(private)
size_t :: c.int32_t
os_thread_t :: c.uintptr_t
os_cond_t :: c.uintptr_t
os_mutex_t :: c.uintptr_t
os_dl_t :: c.uintptr_t
os_sock_t :: c.uintptr_t
flags32_t :: c.uint32_t

// Basic procedure type
@(private)
os_proc_t :: proc "c" ()

mixin_kind :: enum c.int
{
    EcsMixinWorld,
    EcsMixinEntity,
    EcsMixinObservable,
    EcsMixinIterable,
    EcsMixinDtor,
    EcsMixinBase,
    EcsMixinMax,
}

mixins_t :: struct
{
    type_name: cstring,
    elems: [mixin_kind.EcsMixinMax]size_t,
}

// Header for poly_t
header_t :: struct
{
    magic: c.int32_t,
    type: c.int32_t,
    mixins: ^mixins_t,
}