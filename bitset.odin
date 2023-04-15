package flecs

BitSet :: struct
{
    data: [^]u64,
    count: i32,
    size: Size,
}