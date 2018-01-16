#ifndef _STOMP_CH
#define _STOMP_CH

#include "totvs.ch"
#include "stomp_totvs_compat.ch"

#include "stomp_frame.ch"
#include "stomp_frame_header.ch"
#include "stomp_socket.ch"

#define STOMP_DEFAULT_PORT 61613

// Limits -- http://stomp.github.io/stomp-specification-1.2.html#Size_Limits

#define STOMP_HEADERS_COUNT_LIMIT 10
#define STOMP_HEADER_SIZE_LIMIT   256
#define STOMP_BODY_SIZE_LIMIT     (64*1024)

#endif