package flecs

import "core:c"

From_JSON_Desc :: struct
{
    name: cstring,
    expr: cstring,
    lookup_action: proc "c" (_: ^World, value: cstring, ctx: rawptr) -> Entity,
    lookup_ctx: rawptr,
}

Entity_To_JSON_Desc :: struct
{
    serialize_path: c.bool,
    serialize_meta_ids: c.bool,
    serialize_label: c.bool,
    serialize_brief: c.bool,
    serialize_link: c.bool,
    serialize_color: c.bool,
    serialize_id_labels: c.bool,
    serialize_base: c.bool,
    serialize_private: c.bool,
    serialize_hidden: c.bool,
    serialize_values: c.bool,
    serialize_type_info: c.bool,
}

ENTITY_TO_JSON_INIT : Entity_To_JSON_Desc : Entity_To_JSON_Desc {
    true, false, false, false, false, false, false, true, false, false, false, false,
}

Iter_To_JSON_Desc :: struct
{
    serialize_term_ids: c.bool,
    serialize_ids: c.bool,
    serialize_sources: c.bool,
    serialize_variables: c.bool,
    serialize_is_set: c.bool,
    serialize_values: c.bool,
    serialize_entities: c.bool,
    serialize_entity_labels: c.bool,
    serialize_entity_ids: c.bool,
    serialize_entity_names: c.bool,
    serialize_variable_labels: c.bool,
    serialize_variable_ids: c.bool,
    serialize_colors: c.bool,
    measure_eval_duration: c.bool,
    serialize_type_info: c.bool,
    serialize_table: c.bool,
}

ITER_TO_JSON_INIT : Iter_To_JSON_Desc : Iter_To_JSON_Desc {
    true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false,
}

World_To_JSON_Desc :: struct
{
    serialize_builtin: c.bool,
    serialize_modules: c.bool,
}