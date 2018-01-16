#include "stomp.ch"

CLASS TStompFrameBuilder

  METHOD Create() CONSTRUCTOR
  METHOD buildConnectFrame( cHost )
  METHOD buildSendFrame( cDestination, cMessage )
  METHOD buildSubscribeFrame( cDestination, cID )
  METHOD buildDisconnectFrame( cReceipt )
  METHOD buildAckFrame( cIdMessage, cIdTransaction )

  DATA oStompFrame HIDDEN


ENDCLASS

METHOD Create() CLASS TStompFrameBuilder

  ::oStompFrame := TStompFrame():new()

RETURN (SELF)

METHOD buildConnectFrame( cHost ) CLASS TStompFrameBuilder

  //  ::oStompFrame := TStompFrame():new()
  ::oStompFrame:setCommand( STOMP_CLIENT_COMMAND_STOMP )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, STOMP_ACCEPTED_VERSIONS ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, "/" ) )

RETURN ( ::oStompFrame )  //RETURN ( ::oStompFrame )

METHOD buildSendFrame( cDestination, cMessage ) CLASS TStompFrameBuilder
  //LOCAL oStompFrame
 // oStompFrame := TStompFrame():new()
  ::oStompFrame:setCommand( STOMP_CLIENT_COMMAND_SEND )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, cDestination ) )
  ::oStompFrame:setBody( cMessage )

  RETURN ( ::oStompFrame )

METHOD buildDisconnectFrame() CLASS TStompFrameBuilder
  //LOCAL oStompFrame

  //oStompFrame := TStompFrame():new()
  ::oStompFrame:setCommand( STOMP_CLIENT_COMMAND_DISCONNECT )

  RETURN ( ::oStompFrame )

METHOD buildSubscribeFrame( cDestination, cID, cAckMode ) CLASS TStompFrameBuilder
  //LOCAL oStompFrame

  //oStompFrame := TStompFrame():new()
  ::oStompFrame:setCommand( STOMP_CLIENT_COMMAND_SUBSCRIBE )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, cDestination ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cID ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACK_HEADER, cAckMode ) )

  RETURN ( ::oStompFrame )


METHOD buildAckFrame( cIdMessage, cIdTransaction ) CLASS TStompFrameBuilder
Default cIdTransaction := ""

  ::oStompFrame:setCommand( STOMP_CLIENT_COMMAND_ACK )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cIdMessage ) )
  if !Empty(cIdTransaction)  // STOMP_TRANSACTION_ID Nao implementado ainda.
    ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_ID, cIdTransaction ) )
  endif

  RETURN ( ::oStompFrame )
