#ifdef __HARBOUR__
#include "stomp.ch"

CLASS TStompSocket

  DATA hSocket
  DATA nStatus
  DATA lConnected
  DATA oError
  DATA cBuffer
  DATA cReceivedData
  DATA cHost
  DATA nPort

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive()
  METHOD disconnect()
  METHOD isConnected()

ENDCLASS

METHOD new() CLASS TStompSocket
  RETURN ( self )

METHOD connect( cHost, nPort ) CLASS TStompSocket

  IF EMPTY( ::hSocket := hb_socketOpen() )
    ::oError := ErrorNew( "ESocketOpen",,, ProcName(), "Socket create error " + hb_ntos( hb_socketGetError() ) )
    //Throw( ::oError )
  ENDIF

  IF !hb_socketConnect( ::hSocket, { HB_SOCKET_AF_INET, cHost, nPort } )
    ::oError := ErrorNew( "ESocketConnect",,, ProcName(), "Socket connect error " + hb_ntos( hb_socketGetError() ) )
    //Throw( ::oError )
  ENDIF

  RETURN( NIL )

METHOD send( cStompFrame ) CLASS TStompSocket

  hb_socketSend( ::hSocket, ALLTRIM( cStompFrame ) )

  #ifdef DEBUG
  OutStd( ">>>", hb_EOL() )
  OutStd( ALLTRIM( cStompFrame ), hb_EOL() )
  #endif

 RETURN ( NIL )

METHOD receive() CLASS TStompSocket
  LOCAL cBuffer := Space( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := hb_socketRecv( ::hSocket, @cBuffer, STOMP_SOCKET_BUFFER_SIZE, 0 , 10000 )
  IF ( nLen > 0 )
    ::cReceivedData := ALLTRIM( cBuffer )
  ENDIF

  #ifdef DEBUG
  OutStd( "<<<", hb_EOL() )
  OutStd( ALLTRIM( cBuffer ), hb_EOL() )
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::lConnected := .F.
  hb_socketShutdown( ::hSocket )
  hb_socketClose( ::hSocket )

  ::hSocket := nil

  RETURN ( NIL )

METHOD isConnected() CLASS TStomSocket
RETURN ( ::lConnected )

#endif //__HARBOUR__