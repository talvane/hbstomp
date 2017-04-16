#include "stomp.ch"

USER FUNCTION HBSTOMP()

  LOCAL oStompClient

  oStompClient := TStompClient():new("172.20.0.2", 61613)
  ConOut("Instanciou" + CRLF)
  oStompClient:connect()
  ConOut("Solicitou conexao" + CRLF)

  IF oStompClient:isConnected()
  	ConOut("CONECTOU" + CRLF)
    oStompClient:publish( "/queue/hbstomp", "First  message." )
    ConOut("PUBLICOU" + CRLF)
    oStompClient:subscribeTo( "/queue/hbstomp" )
    ConOut("SUBSCREVEU" + CRLF)
  ELSE
    ConOut( "Failed to connect." + CRLF )
    ConOut( "Message: " + oStompClient:getErrorMessage() + CRLF )
  ENDIF

  oStompClient:disconnect()
  ConOut("DISCONECTOU" + CRLF)


  RETURN ( NIL )
