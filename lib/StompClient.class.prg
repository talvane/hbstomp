#include "stomp.ch"

//TODO - handle Stomp Server ERROR frames
//TODO - handle TStompSocket errors
//TODO - return exceptions to users of TStompClient
//TODO - handle receipts
//TODO - handle ack, nack
//TODO - handle transactions
//TODO - handle many subscriptions on a single connection
//TODO - implemente readframe()

CLASS TStompClient

  METHOD new( cHost, nPort )
  METHOD connect()
  METHOD disconnect()
  METHOD publish( cDestination, cMessage )
  METHOD isConnected()
  METHOD getErrorMessage()
  METHOD subscribeTo( cDestination )
  METHOD Ack( cIdMessage, cIdTransaction )
  METHOD readFrame()
  METHOD countFramesToRead()
  METHOD addFrame()

  DATA lRequireReceipt INIT .F.
  DATA aMessages

//  HIDDEN:
  DATA oSocket HIDDEN
  DATA cHost   HIDDEN
  DATA nPort   HIDDEN
  DATA lConnected HIDDEN
  DATA cErrorMessage HIDDEN
  DATA aFrames HIDDEN
  DATA oStompFrame HIDDEN

ENDCLASS

METHOD new( cHost, nPort ) CLASS TStompClient
  ::cHost := cHost
  ::nPort := nPort
  ::lConnected := .F.
  ::aMessages := {}
  ::aFrames := {}
  RETURN ( self )

METHOD connect() CLASS TStompClient
LOCAL oStompBFrame, cFrameBuffer  //LOCAL oStompFrame, oStompBFrame, cFrameBuffer

  ::oSocket := TStompSocket():new()
  ::oSocket:connect( ::cHost, ::nPort )

  IF ::oSocket:isConnected()
    ::lConnected := .T.

   oStompBFrame := TStompFrameBuilder():Create()
   oStompFrame := oStompBFrame:buildConnectFrame( ::cHost )
   // oStompFrame := TGStompFrame():buildConnectFrame( ::cHost )
    ::oSocket:send( oStompFrame:Build() )

    IF ( ( ::oSocket:receive() > 0 ) )
      cFrameBuffer := ::oSocket:cReceivedData
      oStompFrame := oStompFrame:parse( cFrameBuffer )

      IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_CONNECTED )
        ::lConnected := .T.
      ELSE
        IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
          ::cErrorMessage := oStompFrame:cMessage
        ENDIF
      ENDIF

    ENDIF
  ELSE
  //TODO : implement socket connection error handling
  ENDIF

  RETURN ( nil )

METHOD getErrorMessage() CLASS TStompClient
  RETURN ( ::cErrorMessage )

METHOD publish( cDestination, cMessage ) CLASS TStompClient
LOCAL oStompBFrame  //  LOCAL oStompFrame, oStompBFrame

  oStompBFrame := TStompFrameBuilder():Create()
  oStompFrame := oStompBFrame:buildSendFrame( cDestination, cMessage )
  ::oSocket:send( oStompFrame:build() )

  RETURN ( nil )

METHOD disconnect() CLASS TStompClient
LOCAL oStompBFrame //  LOCAL oStompFrame, oStompBFrame

  oStompBFrame := TStompFrameBuilder():Create()
  oStompFrame := oStompBFrame:buildDisconnectFrame()
  ::oSocket:send( oStompFrame:build() )

  ::oSocket:disconnect()

  ::lConnected := .F.

  RETURN ( nil )

METHOD isConnected() CLASS TStompClient
  RETURN ( ::lConnected )

METHOD subscribeTo( cDestination ) CLASS TStompClient
LOCAL oStompBFrame, i := 0, cFrameBuffer  //  LOCAL oStompFrame, oStompBFrame, i := 0, cFrameBuffer

  oStompBFrame := TStompFrameBuilder():Create()
  oStompFrame := oStompBFrame:buildSubscribeFrame( cDestination, "1", "client" )
  ::oSocket:send( oStompFrame:build(), .T. )

  //FIXME : split received data in individual StompFrames
  IF ( ( nLen := ::oSocket:receive() ) > 0 )
    cFrameBuffer := Alltrim(::oSocket:cReceivedData)

    DO WHILE ( Len( cFrameBuffer ) > 0 )
      ConOut( "Frame N: " + cValToChar( ++i ) + CRLF )

      oStompFrame := oStompFrame:parse( @cFrameBuffer )

      IF ( !oStompFrame:isValid() )
        FOR i := 1 TO oStompFrame:countErrors()
          ConOut( "ERRO: " + oStompFrame:aErrors[i] )
        NEXT
      ENDIF

      IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE )
    AADD(::aMessages,oStompFrame:buildSubscribe())
        //ConOut( "Frame Dump" + CRLF + oStompFrame:build() + CRLF )
      ELSE
        IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
          ::cErrorMessage := oStompFrame:cMessage
        ENDIF
      ENDIF
    ENDDO

  ENDIF
RETURN ( nil )

METHOD countFramesToRead() CLASS TStompClient
  RETURN ( LEN( ::aFrames ) )

METHOD addFrame( oStompFrame ) CLASS TStompClient
  AADD( ::aFrames, oStompFrame )
  RETURN ( NIL )

METHOD readFrame() CLASS TStompClient //Ajustar Metodo !
  //LOCAL oStompFrame

  RETURN ( oStompFrame )

METHOD Ack( cIdMessage, cIdTransaction ) CLASS TStompClient
  Local oStompBFrame, i := 0, cFrameBuffer //LOCAL oStompFrame, oStompBFrame, i := 0, cFrameBuffer

  Default cIdTransaction := ""
  oStompBFrame := TStompFrameBuilder():Create()
  oStompFrame := oStompBFrame:buildAckFrame( cIdMessage, cIdTransaction )
  ::oSocket:send( oStompFrame:build() )

RETURN ( nil )
