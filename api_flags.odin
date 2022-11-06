package flecs

import "core:c"

ID_FLAG_BIT :: c.ulonglong(1) << 63

IdBitFlags :: enum id_t
{
    PAIR = c.ulonglong(1) << 63,
    OVERRIDE = c.ulonglong(1) << 62,
    TOGGLE = c.ulonglong(1) << 61,
    AND = c.ulonglong(1) << 60,
}

// Builtin components and tags
EcsQuery : Entity : 5
EcsObserver : Entity : 7

// System module component ids
EcsSystem : Entity : 10
EcsTickSource : Entity : 11

// Timer module component ids
EcsTimer : Entity : 13
EcsRateFilter : Entity : 14

// Root scope for builtin flecs entities
EcsFlecs : Entity : HI_COMPONENT_ID + 1

// Core module scope
EcsFlecsCore : Entity : HI_COMPONENT_ID + 2

// Entity associated with world
EcsWorld : Entity : HI_COMPONENT_ID + 0

// Wildcard entity
EcsWildcard : Entity : HI_COMPONENT_ID + 10

// Any entity
EcsAny : Entity : HI_COMPONENT_ID + 11

// This entity
EcsThis : Entity : HI_COMPONENT_ID + 12

// Variable entity ("$")
EcsVariable : Entity : HI_COMPONENT_ID + 13

// Marks relationship as transitive
//
// if R(X, Y) and R(Y, Z) then R(X, Z)
EcsTransitive : Entity : HI_COMPONENT_ID + 14

// Marks relationship as reflexive
//
// R(X, X) == true
EcsReflexive : Entity : HI_COMPONENT_ID + 15

// Entity/Component cannot be used as target in IsA relationships
//
// if IsA(X, Y) and Final(Y) throw error
EcsFinal : Entity : HI_COMPONENT_ID + 17

// Component is never inherited from an IsA target
//
// if DontInherit(X) and X(B) and IsA(A, B) then X(A) is false
EcsDontInherit : Entity : HI_COMPONENT_ID + 18

// Marks relationship as commutative.
//
// if R(X, Y) then R(Y, X)
EcsSymmetric : Entity : HI_COMPONENT_ID + 16

// Relationship can only be added once, a 2nd instance will
// replace the first
//
// R(X, Y) + R(X, Z) = R(X, Z)
EcsExclusive : Entity : HI_COMPONENT_ID + 21

// Marks relationship as acyclic
EcsAcyclic : Entity : HI_COMPONENT_ID + 22

// Component is always added together with another component
//
// If With(R, O) and R(X) then O(X)
// If With(R, O) and R(X, Y) then O(X, Y)
EcsWith : Entity : HI_COMPONENT_ID + 23

// Relationship target is child of specified entity
//
// If OneOf(R, O) and R(X, Y), Y must be a child of O
// If OneOf(R) and R(X, Y), Y must be a child of R
EcsOneOf : Entity : HI_COMPONENT_ID + 24

// Can be added to relationship to indicate that it should never
// hold data when it or the relationship target is a component.
EcsTag : Entity : HI_COMPONENT_ID + 19

// Tag to indicate that relationship is stored as union.
EcsUnion : Entity : HI_COMPONENT_ID + 20

// Tag to indicate name identifier
EcsName : Entity : HI_COMPONENT_ID + 30

// Tag to indicate symbol identifier
EcsSymbol : Entity : HI_COMPONENT_ID + 31

// Tag to indicate alias identifier
EcsAlias : Entity : HI_COMPONENT_ID + 32

// Used to express parent-child relationships
EcsChildOf : Entity : HI_COMPONENT_ID + 25

// Used to express inheritance relationships
EcsIsA : Entity : HI_COMPONENT_ID + 26

// Used to express dependency relationships
EcsDependsOn : Entity : HI_COMPONENT_ID + 27

// Used to express a slot (used with prefab inheritance)
EcsSlotOf : Entity : HI_COMPONENT_ID + 8

// Tag added to module entities
EcsModule : Entity : HI_COMPONENT_ID + 4

// Tag to indicate an entity/component/system is private to a module
EcsPrivate : Entity : HI_COMPONENT_ID + 5

// Tag added to prefab entities
EcsPrefab : Entity : HI_COMPONENT_ID + 6

// When this tag is added to an entity it is skipped by all queries /
// filters
EcsDisabled : Entity : HI_COMPONENT_ID + 7

// Event. Triggers when an id is added to an entity
EcsOnAdd : Entity : HI_COMPONENT_ID + 33

// Event. Triggers when an id is removed from an entity
EcsOnRemove : Entity : HI_COMPONENT_ID + 34

// Event. Triggers when a component is set for an entity
EcsOnSet : Entity : HI_COMPONENT_ID + 35

// Event. Triggers when a component is unset for an entity
EcsUnSet : Entity : HI_COMPONENT_ID + 36

// Event. Exactly-once observer for when an entity matches /
// unmatches a filter
EcsMonitor : Entity : HI_COMPONENT_ID + 61

// Event. Triggers when an entity is deleted.
EcsOnDelete : Entity : HI_COMPONENT_ID + 37

// Event. Triggers when a table becomes empty
EcsOnTableEmpty : Entity : HI_COMPONENT_ID + 40

// Event. Triggers when a table becomes non-empty.
EcsOnTableFill : Entity : HI_COMPONENT_ID + 41

// Relationship used to define what should happen when a target
// entity is deleted.
EcsOnDeleteTarget : Entity : HI_COMPONENT_ID + 46

// Remove cleanup policy.
EcsRemove : Entity : HI_COMPONENT_ID + 50

// Delete cleanup policy.
EcsDelete : Entity : HI_COMPONENT_ID + 51

// Panic cleanup policy.
EcsPanic : Entity : HI_COMPONENT_ID + 52

// When added to an entity, this informs serialization formats
// which component to use when a value is assigned to an entity
// without specifying the component.
EcsDefaultChildComponent : Entity : HI_COMPONENT_ID + 55

// Tag used to indicate when query is empty
EcsEmpty : Entity : HI_COMPONENT_ID + 63

// Pipeline module tags
EcsPipelineTag : Entity : HI_COMPONENT_ID + 64
EcsPreFrame : Entity : HI_COMPONENT_ID + 65
EcsOnLoad : Entity : HI_COMPONENT_ID + 66
EcsPostLoad : Entity : HI_COMPONENT_ID + 67
EcsPreUpdate : Entity : HI_COMPONENT_ID + 68
EcsOnUpdate : Entity : HI_COMPONENT_ID + 69
EcsOnValidate : Entity : HI_COMPONENT_ID + 70
EcsPostUpdate : Entity : HI_COMPONENT_ID + 71
EcsPreStore : Entity : HI_COMPONENT_ID + 72
EcsOnStore : Entity : HI_COMPONENT_ID + 73
EcsPostFrame : Entity : HI_COMPONENT_ID + 74
EcsPhase : Entity : HI_COMPONENT_ID + 75

// EcsLastInternalComponentId

EcsFirstUserComponentId :: 32

EcsFirstUserEntityId :: HI_COMPONENT_ID + 128