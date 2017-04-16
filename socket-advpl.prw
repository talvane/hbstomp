#ifdef TOTVS
#include "totvs.ch"
#else
#include "protheus.ch"
#endif

#DEFINE MSECONDS_WAIT 5000
#define CHR_NULL  chr(0)
#define CHR_CR    chr(13)
#define CHR_LF    chr(10)
#define CHR_CRLF  CHR_CR+CHR_LF

USER FUNCTION STOMP()

  LOCAL cConnect
  LOCAL cSend
  LOCAL cSubscribe

	Local nVarNameL			:= SetVarNameLen( 20 )

  Local lGetError			:= .F.

	Local ctSocketSend
	Local ctSocketReceive

	Local ntSocketReset
	Local ntSocketConnected

	Local ntSocketSend
	Local ntSocketReceive

	//Instanciamos um objeto do tipo Socket Client
	Local otSocketC	:= tSocketClient():New()

  cConnect   := "STOMP"
  cConnect   += CHR_CRLF
  cConnect   += "accept-version:1.2"
  cConnect   += CHR_CRLF
  cConnect   += "host:/"
  cConnect   += CHR_CRLF
  cConnect   += CHR_CRLF
  cConnect   += CHR_NULL

  cSend      := "SEND"
  cSend      += CHR_CRLF
  cSend      += "destination:/queue/hbstomp"
  cSend      += CHR_CRLF
  cSend      += CHR_CRLF
  cSend      += "First  message."
  cSend      += CHR_CRLF
  cSend      += CHR_NULL

  cSubscribe := "SUBSCRIBE"
  cSubscribe += CHR_CRLF
  cSubscribe += "destination:/queue/hbstomp"
  cSubscribe += CHR_CRLF
  cSubscribe += "id:hbstomp-1"
  cSubscribe += CHR_CRLF
  cSubscribe += CHR_CRLF
  cSubscribe += CHR_NULL

	BEGIN SEQUENCE

		ntSocketConnected	:= otSocketC:Connect( 61613 , "172.20.0.2" , MSECONDS_WAIT )

    //Verificamos se a conexao foi efetuada com sucesso
		IF !( otSocketC:IsConnected() ) //ntSocketConnected == 0 OK
			IF ( lGetError )
				ConOut( otSocketC:GetError() )
			EndIF
			ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			BREAK
		EndIF

		//Enviamos uma Mensagem
		ntSocketSend := otSocketC:Send( cConnect )
		//Se a mensagem foi totalmente enviada
		IF ( ntSocketSend == Len( cConnect ) )
			//Tentamos Obter a Resposta aguardando por n milisegundos
			ntSocketReceive := otSocketC:Receive( @ctSocketReceive , MSECONDS_WAIT )
			//Se Obtive alguma Resposta
			IF ( ntSocketReceive > 0 )
				//Direcionamo-a para o Console do Server
				ConOut( "" , ctSocketReceive , "" )
			Else
				IF ( lGetError )
					ConOut( otSocketC:GetError() )
				EndIF
				ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			EndIF
		Else
			IF ( lGetError )
				ConOut( otSocketC:GetError() )
			EndIF
			ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
		EndIF

		//Verificamos se ainda esta Conectado
		IF !( otSocketC:IsConnected() )
			//Tentamos Nova Conexao
			ntSocketReset 		:= otSocketC:ReSet() //ntSocketReset == 0 OK
			ntSocketConnected	:= otSocketC:Connect( 61613 , "172.20.0.2" , MSECONDS_WAIT )
		EndIF
		//Se permanecemos conectado ou reconectou
		IF !( otSocketC:IsConnected() ) //ntSocketConnected == 0 OK
			IF ( lGetError )
				ConOut( otSocketC:GetError() )
			EndIF
			ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			BREAK
		EndIF

		//Enviamos a nova Mensagem
		ntSocketSend := otSocketC:Send( cSend )
		//Se a mensagem foi totalmente enviada
		IF ( ntSocketSend == Len( cSend ) )
			//Tentamos Obter a Resposta aguardando por n milisegundos
			ntSocketReceive := otSocketC:Receive( @ctSocketReceive , MSECONDS_WAIT )
			//Se Obtive alguma Resposta
			IF ( ntSocketReceive > 0 )
				//Direcionamo-a para o Console do Server
				ConOut( "" , ctSocketReceive , "" )
			Else
				IF ( lGetError )
					ConOut( otSocketC:GetError() )
				EndIF
				ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			EndIF
		Else
			IF ( lGetError )
				ConOut( otSocketC:GetError() )
			EndIF
			ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
		EndIF

	END SEQUENCE


	//Encerramos a Conexao
	otSocketC:CloseConnection()
	otSocketC	:= NIL

	SetVarNameLen( nVarNameL )

RETURN ( NIL )