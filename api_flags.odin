package flecs

import "core:c"

World_Flags :: enum u32
{
    Quit_Workers = 1 << 0,
    Readonly = 1 << 1,
    Init = 1 << 2,
    Quit = 1 << 3,
    Fini = 1 << 4,
    Measure_Frame_Time = 1 << 5,
    Measure_System_Time = 1 << 6,
    Multi_Threaded = 1 << 7,
}

OS_API_Flags :: enum u32
{
    High_Resolution_Timer = 1 << 0,
    Log_With_Colors = 1 << 1,
    Log_With_Time_Stamp = 1 << 2,
    Log_With_Time_Delta = 1 << 3,
}

Entity_Flags :: enum u32
{
    Is_Id = 1 << 31,
    Is_Target = 1 << 30,
    Is_Traversable = 1 << 29,
}

Id_Flags :: enum u32
{
    On_Delete_Remove = 1 << 0,
    On_Delete_Delete = 1 << 1,
    On_Delete_Panic = 1 << 2,
    On_Delete_Mask = (On_Delete_Remove|On_Delete_Delete|On_Delete_Panic),

    On_Delete_Object_Remove = 1 << 3,
    On_Delete_Object_Delete = 1 << 4,
    On_Delete_Object_Panic = 1 << 5,
    On_Delete_Object_Mask = (On_Delete_Object_Remove|On_Delete_Object_Delete|On_Delete_Object_Panic),

    Exclusive = 1 << 6,
    Dont_Inherit = 1 << 7,
    Traversable = 1 << 8,
    Tag = 1 << 9,
    With = 1 << 10,
    Union = 1 << 11,
    Always_Override = 1 << 12,

    Has_On_Add = 1 << 15,
    Has_On_Remove = 1 << 16,
    Has_On_Set = 1 << 17,
    Has_Un_Set = 1 << 18,
    Event_Mask = (Has_On_Add|Has_On_Remove|Has_On_Set|Has_Un_Set),

    Marked_For_Delete = 1 << 30,
}

// Ignore utilities

Iterator_Flags :: enum u32
{
    Is_Valid = 1 << 0,
    No_Data = 1 << 1,
    Is_Instanced = 1 << 2,
    Has_Shared = 1 << 3,
    Table_Only = 1 << 4,
    Entity_Optional = 1 << 5,
    No_Results = 1 << 6,
    Ignore_This = 1 << 7,
    Match_Var = 1 << 8,
    Has_Cond_Set = 1 << 10,
    Profile = 1 << 11,
}

Event_Filter_Flags :: enum u32
{
    Table_Only = 1 << 8,
    No_On_Set = 1 << 16,
}

Filter_Flags :: enum u32
{
    Match_This = 1 << 1,
    Match_Only_This = 1 << 2,
    Match_Prefab = 1 << 3,
    Match_Disabled = 1 << 4,
    Match_Empty_Tables = 1 << 5,
    Match_Anything = 1 << 6,
    No_Data = 1 << 7,
    Is_Instanced = 1 << 8,
    Populate = 1 << 9,
    Has_Cond_Set = 1 << 10,
    Unresolved_By_Name = 1 << 11,
}

Table_Flags :: enum u32
{
    Has_Builtins = 1 << 1,
    Is_Prefab = 1 << 2,
    Has_Is_A = 1 << 3,
    Has_Child_Of = 1 << 4,
    Has_Pairs = 1 << 5,
    Has_Module = 1 << 6,
    Is_Disabled = 1 << 7,
    Has_Ctors = 1 << 8,
    Has_Dtors = 1 << 9,
    Has_Copy = 1 << 10,
    Has_Move = 1 << 11,
    Has_Union = 1 << 12,
    Has_Toggle = 1 << 13,
    Has_Overrides = 1 << 14,

    Has_On_Add = 1 << 15,
    Has_On_Remove = 1 << 16,
    Has_On_Set = 1 << 17,
    Has_Un_Set = 1 << 18,

    Has_Observed = 1 << 20,
    Has_Target = 1 << 21,

    Marked_For_Delete = 1 << 30,

    // Composites
    Has_Lifecycle = (Has_Ctors|Has_Dtors),
    Is_Complex = (Has_Lifecycle|Has_Union|Has_Toggle),
    Has_Add_Actions = (Has_Is_A|Has_Union|Has_Ctors|Has_On_Add|Has_On_Set),
    Has_Remove_Actions = (Has_Is_A|Has_Dtors|Has_On_Remove|Has_Un_Set),
}

Query_Flags :: enum u32
{
    Has_Refs = 1 << 1,
    Is_Subquery = 1 << 2,
    Is_Orphaned = 1 << 3,
    Has_Out_Columns = 1 << 4,
    Has_Monitor = 1 << 5,
    Trivial_Iter = 1 << 6,
}

Aperiodic_Action_Flags :: enum u32
{
    Empty_Tables = 1 << 1,
    Component_Monitors = 1 << 2,
    Empty_Queries = 1 << 4,
}