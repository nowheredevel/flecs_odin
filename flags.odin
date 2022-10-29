package flecs

import "core:c"

WorldFlags :: enum uint
{
    QuitWorkers = 1 << 0,
    Readonly = 1 << 1,
    Quit = 1 << 2,
    Fini = 1 << 3,
    MeasureFrameTime = 1 << 4,
    MeasureSystemTime = 1 << 5,
    MultiThreaded = 1 << 6,
}

OsApiFlags :: enum uint
{
    HighResolutionTimer = 1 << 0,
    LogWithColors = 1 << 1,
    LogWithTimeStamp = 1 << 2,
    LogWithTimeDelta = 1 << 3,
}

EntityFlags :: enum uint
{
    Observed = 1 << 31,
    ObservedId = 1 << 30,
    ObservedTarget = 1 << 29,
    ObservedAcyclic = 1 << 28,
}

IdFlags :: enum uint
{
    OnDeleteRemove = 1 << 0,
    OnDeleteDelete = 1 << 1,
    OnDeletePanic = 1 << 2,
    OnDeleteMask = (OnDeletePanic|OnDeleteRemove|OnDeleteDelete),
    
    OnDeleteObjectRemove = 1 << 3,
    OnDeleteObjectDelete = 1 << 4,
    OnDeleteObjectPanic = 1 << 5,
    OnDeleteObjectMask = (OnDeleteObjectPanic|OnDeleteObjectRemove|OnDeleteObjectDelete),

    Exclusive = 1 << 6,
    DontInherit = 1 << 7,
    Acyclic = 1 << 8,
    Tag = 1 << 9,
    With = 1 << 10,
    Union = 1 << 11,

    HasOnAdd = 1 << 15, // Same values as table flags
    HasOnRemove = 1 << 16,
    HasOnSet = 1 << 17,
    HasUnSet = 1 << 18,
    EventMask = (HasOnAdd|HasOnRemove|HasOnSet|HasUnSet),

    MarkedForDelete = 1 << 30,
}

IterFlags :: enum uint
{
    IsValid = 1 << 0,
    IsFilter = 1 << 1,
    IsInstanced = 1 << 2,
    HasShared = 1 << 3,
    TableOnly = 1 << 4,
    EntityOptional = 1 << 5,
    NoResults = 1 << 6,
    IgnoreThis = 1 << 7,
    MatchVar = 1 << 8,
}

EventFlags :: enum uint
{
    TableOnly = 1 << 8,
    NoOnSet = 1 << 16,
}

FilterFlags :: enum uint
{
    MatchThis = 1 << 1,
    MatchOnlyThis = 1 << 2,
    MatchPrefab = 1 << 3,
    MatchDisabled = 1 << 4,
    MatchEmptyTables = 1 << 5,
    MatchAnything = 1 << 6,
    IsFilter = 1 << 7,
    IsInstanced = 1 << 8,
    Populate = 1 << 9,
}

TableFlags :: enum uint
{
    HasBuiltins = 1 << 1,
    IsPrefab = 1 << 2,
    HasIsA = 1 << 3,
    HasChildOf = 1 << 4,
    HasPairs = 1 << 5,
    HasModule = 1 << 6,
    IsDisabled = 1 << 7,
    HasCtors = 1 << 8,
    HasDtors = 1 << 9,
    HasCopy = 1 << 10,
    HasMove = 1 << 11,
    HasUnion = 1 << 12,
    HasToggle = 1 << 13,
    HasOverrides = 1 << 14,

    HasOnAdd = 1 << 15,
    HasOnRemove = 1 << 16,
    HasOnSet = 1 << 17,
    HasUnSet = 1 << 18,

    HasObserved = 1 << 20,
    MarkedForDelete = 1 << 30,

    HasLifecycle = (HasCtors | HasDtors),
    IsComplex = (HasLifecycle | HasUnion | HasToggle),
    HasAddActions = (HasIsA | HasUnion | HasCtors | HasOnAdd | HasOnSet),
    HasRemoveActions = (HasIsA | HasDtors | HasOnRemove | HasUnSet),
}

QueryFlags :: enum uint
{
    HasRefs = 1 << 1,
    IsSubquery = 1 << 2,
    IsOrphaned = 1 << 3,
    HasOutColumns = 1 << 4,
    HasMonitor = 1 << 5,
}

AperiodicFlags :: enum uint
{
    EmptyTables = 1 << 1,
    ComponentMonitors = 1 << 2,
    EmptyQueries = 1 << 3,
}