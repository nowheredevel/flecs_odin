# flecs-odin
 An almost complete binding of flecs to the Odin programming language,
 version should match up with the latest flecs release (current: 3.1.0)
 
## NOTE
 This is basically complete, with most core functionality (including systems) working, but some things like modules aren't included because I stopped working on this a while ago. If you'd like to contribute, feel free to open a pull request!

## Usage
Bindings should work on all platforms, just place the dynamic library for flecs in the root of your project (or wherever the executable is run) and the bindings will work immediately.

## Style Guide
- Functions use snake_case
- Types use PascalCase
- Macros use WHATEVER_THIS_IS
- Type aliases use typename_t
