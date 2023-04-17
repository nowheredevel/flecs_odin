package flecs

import "core:c"

MAX_COMPONENT_ID :: ~cast(u32)(ID_FLAGS_MASK >> 32)
MAX_RECURSION :: 512
MAX_TOKEN_SIZE :: 256

// Ignore bit sets