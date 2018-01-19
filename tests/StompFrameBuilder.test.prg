#include "stomp.ch"

CLASS TTestStompFrameBuilder FROM TTestCase

  METHOD testBuildConnectFrame()
  METHOD testBuildDisconectFrame()
  METHOD testBuildConnectFrameWithoutHost()
  METHOD testBuildConnectFrameWithLoginInfo()

ENDCLASS

METHOD testBuildConnectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( "127.0.0.1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid")
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_STOMP,  "Frame command should be STOMP" )
  ::assert:equals( oStompFrame:getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ), STOMP_ACCEPTED_VERSIONS, "accepted-versions header should default" )
  ::assert:equals( oStompFrame:getHeaderValue("host"), "127.0.0.1", "header host should be '127.0.0.1'" )

  RETURN ( nil )

METHOD testBuildConnectFrameWithoutHost() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame()
  ::assert:false( oStompFrame:headerExists(STOMP_HOST_HEADER), "header host should not exist" )

  RETURN ( nil )

METHOD testBuildConnectFrameWithLoginInfo() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( , 'user', 'pass' )
  ::assert:true( oStompFrame:headerExists(STOMP_LOGIN_HEADER), "header login should exist" )
  ::assert:true( oStompFrame:headerExists(STOMP_PASSCODE_HEADER), "header passcode should exist" )

  RETURN ( nil )


METHOD testBuildDisconectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildDisconnectFrame( "receipt-1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid" )
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_DISCONNECT, "Frame command should be DISCONNECT" )

 RETURN ( nil )