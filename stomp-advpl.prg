#include "stomp.ch"

USER FUNCTION HBSTOMP()

  LOCAL oStompClient

  oStompClient := TStompClient():new("192.168.1.33", 61613, "logstash", "logstash", "/", .T.)
  ? "Instanciou", CHR_CRLF
  oStompClient:connect()
  ? "Solicitou conexao", CHR_CRLF

  IF oStompClient:isConnected()
    ? "CONECTOU", CHR_CRLF
    oStompClient:publish( "/queue/hbstomp", "Mensagem do ADVPL" )
    ? "PUBLICOU", CHR_CRLF
    oStompClient:subscribe( "/queue/hbstomp",  )
    ? "SUBSCREVEU", CHR_CRLF
  ELSE
    ? "Failed to connect.", CHR_CRLF
    ? "Message: ", oStompClient:getErrorMessage(), CHR_CRLF
  ENDIF

  oStompClient:disconnect()
  ? "DESCONECTOU", CHR_CRLF

  RETURN ( NIL )
