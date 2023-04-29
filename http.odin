package flecs

import "core:c"

HTTP_HEADER_COUNT_MAX :: 32
HTTP_QUERY_PARAM_COUNT_MAX :: 32
HTTP_SEND_QUEUE_MAX :: 256

when ODIN_OS == .Windows
{
    HTTP_Socket :: c.ulonglong
} else
{
    HTTP_Socket :: c.int
}

HTTP_Send_Request :: struct
{
    sock: HTTP_Socket,
    headers: cstring,
    header_length: i32,
    content: cstring,
    content_length: i32,
}

HTTP_Send_Queue :: struct
{
    requests: [HTTP_SEND_QUEUE_MAX]HTTP_Send_Request,
    head: i32,
    tail: i32,
    thread: OS_Thread,
    wait_ms: i32,
}

// Don't need to implement *every* private http.c struct

HTTP_Server :: struct
{
    should_run: c.bool,
    running: c.bool,
    sock: HTTP_Socket,
    lock: OS_Mutex,
    thread: OS_Thread,
    callback: HTTP_Reply_Action,
    ctx: rawptr,
    connections: Sparse,
    requests: Sparse,
    initialized: c.bool,
    port: u16,
    ipaddr: cstring,
    dequeue_timeout: f64,
    stats_timeout: f64,
    request_time: f64,
    request_time_total: f64,
    requests_processed: i32,
    requests_processed_total: i32,
    dequeue_count: i32,
    send_queue: HTTP_Send_Queue,
    request_cache: HashMap,
}

HTTP_Connection :: struct
{
    id: u64,
    server: ^HTTP_Server,
    host: [128]c.char,
    port: [16]c.char,
}

HTTP_Key_Value :: struct
{
    key: cstring,
    value: cstring,
}

HTTP_Method :: enum
{
    Get,
    Post,
    Put,
    Delete,
    Options,
    Method_Unsupported,
}

HTTP_Request :: struct
{
    id: u64,
    method: HTTP_Method,
    path: cstring,
    body: cstring,
    headers: [HTTP_HEADER_COUNT_MAX]HTTP_Key_Value,
    params: [HTTP_HEADER_COUNT_MAX]HTTP_Key_Value,
    header_count: i32,
    param_count: i32,
    conn: ^HTTP_Connection,
}

HTTP_Reply :: struct
{
    code: c.int,
    body: StrBuf,
    status: cstring,
    content_type: cstring,
    headers: StrBuf,
}

HTTP_REPLY_INIT : HTTP_Reply : HTTP_Reply {200, STRBUF_INIT, "OK", "application/json", STRBUF_INIT}

HTTP_Reply_Action :: #type proc "c" (request: ^HTTP_Request, reply: ^HTTP_Reply, ctx: rawptr) -> c.bool

HTTP_Server_Desc :: struct
{
    callback: HTTP_Reply_Action,
    ctx: rawptr,
    port: u16,
    ipaddr: cstring,
    send_queue_wait_ms: i32,
}