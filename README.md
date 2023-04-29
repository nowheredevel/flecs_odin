# flecs-odin
 An almost complete binding of flecs to the Odin programming language,
 version should match up with the latest flecs release (current: 3.2.1)

## CHANGES
 Because Odin and C have a somewhat similar feature set, function calls are almost exactly the same, just without the ecs_ prefix (e.g. a call to ecs_init() would be replaced with flecs.init()). However, due to some small differences between the languages, certain functionality is different. For example, Odin lacks token pasting and stringizing, so the id() is only used for entity initialization rather than creating an Odin-specific token. However, this also brings some advantages, such as Odin's type info system which allows for creating systems without having to respecify every component parameter. The point is, while the bindings and the root flecs repo have very similar syntax, there are still some smaller low-level qualms.

 Another important change involves Poly (ecs_poly_t). In Flecs, ecs_poly_t is defined as a type alias for a void. However, Odin doesn't have a void type, the closest available is rawptr which is analogous to a void* in C. Luckily, every time ecs_poly_t is used in Flecs it's used as a pointer to ecs_poly_t, never as a raw void. Because of this, Poly in flecs_odin is defined as a rawptr, and every usage of *ecs_poly_t in Flecs' source is replaced with just Poly (not ^Poly) in flecs_odin.

## BRANCH NOTE
 This branch is for a complete rewrite of the repo. The goals of this branch are to ensure full support for flecs 3.2.1, while also having compliance with Odin's naming conventions and properly organized files.
 
## NOTE
 This is basically complete, with most core functionality (including systems) working, but some things like modules aren't included because I stopped working on this a while ago. If you'd like to contribute, feel free to open a pull request!

## TODO
 As mentioned before, these bindings are mostly complete but some work is still to be done. This includes:
- A heavy bug-fix check (the code *should* work but I've never actually done a full stress test of it so there may be some unforeseen consequences)
- Ensuring that building and linking works on all platforms (Specifically when it comes to loading the flecs library in the `when` block).

## Usage
Bindings should work on all platforms, just place the dynamic library for flecs in the root of your project (or wherever the executable is run) and the bindings will work immediately.

## Style Guide
- Functions use snake_case
- Types use Pascal_Snake_Whatever_Case
- Macros (sometimes) use WHATEVER_THIS_IS
