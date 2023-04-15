package flecs

import "core:c"
import "core:reflect"
import "core:strings"
import "core:runtime"

@(private)
_Get_Type_Name :: proc($T: typeid) -> string
{
    ti := type_info_of(T)
    type_name: string

    #partial switch info in ti.variant
    {
        case runtime.Type_Info_Named:
            type_name = info.name
        case:
            fmt.panicf("Error: Tags can only be structs! Received: ", info)
    }

    return type_name
}