# flecs-odin
 An almost complete binding of flecs to the Odin programming language,
 version should match up with the latest flecs release (current: 3.2.1)

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
