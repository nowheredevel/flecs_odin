# flecs-odin
 An almost complete binding of flecs to the Odin programming language,
 version should match up with the latest flecs release (current: 3.1.0)
 
## NOTE
 This is basically complete, with most core functionality (including systems) working, but some things like modules aren't included because I stopped working on this a while ago. If you'd like to contribute, feel free to open a pull request!

## TODO
 As mentioned before, these bindings are mostly complete but some work is still to be done. This includes:
- Ensuring that the bindings work in newer versions (the current bindings were only developed for flecs 3.1.0)
- Organizing the file structure to be more coherent
- A heavy bug-fix check (the code *should* work but I've never actually done a full stress test of it so there may be some unforeseen consequences)

## Usage
Bindings should work on all platforms, just place the dynamic library for flecs in the root of your project (or wherever the executable is run) and the bindings will work immediately.

## Style Guide
- Functions use snake_case
- Types use PascalCase
- Macros use WHATEVER_THIS_IS
- Type aliases use typename_t
