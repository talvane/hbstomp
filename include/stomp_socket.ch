#ifndef _STOMP_SOCKET_CH
#define _STOMP_SOCKET_CH

#define STOMP_SOCKET_BUFFER_SIZE 4098
#define STOMP_SOCKET_CONNECTION_TIMEOUT 5000 // in miliseconds

// CONNECTION STATUS
#define STOMP_SOCKET_STATUS_CONNECTED         0
#define STOMP_SOCKET_STATUS_MESSAGE_SENT      1
#define STOMP_SOCKET_STATUS_DATA_RECEIVED     2


// CONNECTION ERRORS

#define STOMP_SOCKET_ERROR_CONNECTING         101
#define STOMP_SOCKET_ERROR_RECEIVING_DATA     102

#endif