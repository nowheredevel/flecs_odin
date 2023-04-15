package flecs

import "core:c"

HI_COMPONENT_ID :: 256
HI_ID_RECORD_ID :: 1024
MAX_COMPONENT_ID :: ~cast(u32)(ID_FLAGS_MASK >> 32)
MAX_RECURSION :: 512
MAX_TOKEN_SIZE :: 256

// Ignore bit sets