package flecs

import "core:c"

// Ignore declares because we don't use those macros like that

Ecs_Metric_Value :: struct
{
    value: f64,
}

Ecs_Metric_Source :: struct
{
    entity: Entity,
}

Metric_Desc :: struct
{
    entity: Entity,
    member: Entity,
    id: Id,
    targets: c.bool,
    kind: Entity,
    brief: cstring,
}

// Ignore convenience macro