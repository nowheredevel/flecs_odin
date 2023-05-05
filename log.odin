package flecs

import "core:c"
import "core:c/libc"

print :: proc(level: i32, fmt: cstring, args: ..any)
{
    _print(level, #file, #line, fmt, args)
}

printv :: proc(level: i32, fmt: cstring, args: cstring)
{
    _printv(level, #file, #line, fmt, args)
}

log :: proc(level: i32, fmt: cstring, args: ..any)
{
    _log(level, #file, #line, fmt, args)
}

logv :: proc(level: i32, fmt: cstring, args: cstring)
{
    _logv(level, #file, #line, fmt, args)
}

_trace :: proc(file: cstring, line: i32, fmt: cstring, args: ..any)
{
    _log(0, file, line, fmt, args)
}

trace :: proc(fmt: cstring, args: ..any)
{
    _trace(#file, #line, fmt, args)
}

_warn :: proc(file: cstring, line: i32, fmt: cstring, args: ..any)
{
    _log(-2, file, line, fmt, args)
}

warn :: proc(fmt: cstring, args: ..any)
{
    _warn(#file, #line, fmt, args)
}

_err :: proc(file: cstring, line: i32, fmt: cstring, args: ..any)
{
    _log(-3, file, line, fmt, args)
}

err :: proc(fmt: cstring, args: ..any)
{
    _err(#file, #line, fmt, args)
}

_fatal :: proc(file: cstring, line: i32, fmt: cstring, args: ..any)
{
    _log(-4, file, line, fmt, args)
}

fatal :: proc(fmt: cstring, args: ..any)
{
    _fatal(#file, #line, fmt, args)
}

// Ignore debug logging, flecs should always be compiled in release

abort :: proc(error_code: i32, fmt: cstring, args: ..any)
{
    _abort(error_code, #file, #line, fmt, args)
    os_abort()
    libc.abort()
}

// Ignore assert because it's debug only

// Ignore dummy_check because it uses goto

parser_error :: proc(name: cstring, expr: cstring, column: i64, fmt: cstring, args: ..any)
{
    _parser_error(name, expr, column, fmt, args)
}

parser_errorv :: proc(name: cstring, expr: cstring, column: i64, fmt: cstring, args: cstring)
{
    _parser_errorv(name, expr, column, fmt, args)
}

INVALID_OPERATION :: 1
INVALID_PARAMETER :: 2
CONSTRAINT_VIOLATED :: 3
OUT_OF_MEMORY :: 4
OUT_OF_RANGE :: 5
UNSUPPORTED :: 6
INTERNAL_ERROR :: 7
ALREADY_DEFINED :: 8
MISSING_OS_API :: 9
OPERATION_FAILED :: 10
INVALID_CONVERSION :: 11
ID_IN_USE :: 12
CYCLE_DETECTED :: 13
LEAK_DETECTED :: 14
INCONSISTENT_NAME :: 20
NAME_IN_USE :: 21
NOT_A_COMPONENT :: 22
INVALID_COMPONENT_SIZE :: 23
INVALID_COMPONENT_ALIGNMENT :: 24
COMPONENT_NOT_REGISTERED :: 25
INCONSISTENT_COMPONENT_ID :: 26
INCONSISTENT_COMPONENT_ACTION :: 27
MODULE_UNDEFINED :: 28
MISSING_SYMBOL :: 29
ALREADY_IN_USE :: 30
ACCESS_VIOLATION :: 40
COLUMN_INDEX_OUT_OF_RANGE :: 41
COLUMN_IS_NOT_SHARED :: 42
COLUMN_IS_SHARED :: 43
COLUMN_TYPE_MISMATCH :: 45
INVALID_WHILE_READONLY :: 70
LOCKED_STORAGE :: 71
INVALID_FROM_WORKER :: 72

BLACK :: "\033[1;30m"
RED :: "\033[0;31m"
GREEN :: "\033[0;32m"
YELLOW :: "\033[0;33m"
BLUE :: "\033[0;34m"
MAGENTA :: "\033[0;35m"
CYAN :: "\033[0;36m"
WHITE :: "\033[1;37m"
GREY :: "\033[0;37m"
NORMAL :: "\033[0;49m"
BOLD :: "\033[1;49m"