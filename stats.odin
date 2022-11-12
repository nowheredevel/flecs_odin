package flecs

import "core:c"

STAT_WINDOW : c.int : 60

Gauge :: struct
{
    avg: [STAT_WINDOW]c.float,
    min: [STAT_WINDOW]c.float,
    max: [STAT_WINDOW]c.float,
}

Counter :: struct
{
    rate: Gauge,
    value: [STAT_WINDOW]c.float,
}

Metric :: struct
{
    gauge: Gauge,
    counter: Counter,
}

WorldStats :: struct
{
    first_: c.int32_t,

    entities: struct
    {
        count: Metric,
        not_alive_count: Metric,
    },

    ids: struct
    {
        count: Metric,
        tag_count: Metric,
        component_count: Metric,
        pair_count: Metric,
        wildcard_count: Metric,
        type_count: Metric,
        create_count: Metric,
        delete_count: Metric,
    },

    tables: struct
    {
        count: Metric,
        empty_count: Metric,
        tag_only_count: Metric,
        trivial_only_count: Metric,
        record_count: Metric,
        storage_count: Metric,
        create_count: Metric,
        delete_count: Metric,
    },

    queries: struct
    {
        query_count: Metric,
        observer_count: Metric,
        system_count: Metric,
    },

    commands: struct
    {
        add_count: Metric,
        remove_count: Metric,
        delete_count: Metric,
        clear_count: Metric,
        set_count: Metric,
        get_mut_count: Metric,
        modified_count: Metric,
        other_count: Metric,
        discard_count: Metric,
        batched_entity_count: Metric,
        batched_count: Metric,
    },
}