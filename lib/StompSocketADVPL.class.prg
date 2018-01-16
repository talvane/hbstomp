#include "stomp.ch"
#define DEBUG

#define STOMP_SOCKET_CONNECTION_TIMEOUT 20

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
  METHOD send( cStompFrame ,lRecive )
  METHOD receive()
  METHOD disconnect()
  METHOD isConnected()

ENDCLASS

METHOD new() CLASS TStompSocket
  ::lConnected := .F.
  ::hSocket := tSocketClient():new()

RETURN ( SELF )

METHOD connect( cHost, nPort ) CLASS TStompSocket

  ::nStatus := ::hSocket:connect( nPort , cHost, STOMP_SOCKET_CONNECTION_TIMEOUT )

  IF ::hSocket:isConnected()
    ::lConnected := .T.
  ENDIF

  RETURN ( nil )

METHOD send( cStompFrame, lRecive ) CLASS TStompSocket
  LOCAL nSocketSend
  LOCAL nSocketReceive
  Default lRecive := .F.

  nSocketSend := ::hSocket:send( cStompFrame )

  IF ( nSocketSend == Len( cStompFrame ) )

    #ifdef DEBUG
    Conout( ">>>" + CRLF )
    Conout( ALLTRIM( cStompFrame ) + CRLF )
    #endif

    if !lRecive
      nSocketReceive := ::hSocket:receive( @::cReceivedData , STOMP_SOCKET_CONNECTION_TIMEOUT )

      IF ( ! nSocketReceive > 0 )
        ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
        //IF ( lGetError )
        //  ConOut( ::hSocket:GetError() )
        //EndIF
      ELSE
           #ifdef DEBUG
          Conout( ">>>" + CRLF )
          Conout( ALLTRIM( self:cReceivedData ) + CRLF )
        #endif

      EndIF

    endif //!lRecive

  ELSE
    //IF ( lGetError )
    //  ConOut( ::hSocket:GetError() )
    //EndIF
    ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
  ENDIF

  RETURN ( nil )

METHOD receive() CLASS TStompSocket
  LOCAL cBuffer := SPACE( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := ::hSocket:receive( @cBuffer, STOMP_SOCKET_BUFFER_SIZE )
  IF( nLen >= 0 )
    ::cReceivedData := cBuffer
  ENDIF

  #ifdef DEBUG
  Conout( "<<<" + CRLF )
  Conout( ALLTRIM( cBuffer ) + CRLF )
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::hSocket:CloseConnection()
  ::hSocket := NIL

  RETURN ( nil )

METHOD isConnected() CLASS TStompSocket
RETURN ( ::lConnected )