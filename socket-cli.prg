PROCEDURE MAIN()

  oStompClient := TStompClient():new("127.0.0.1", 61613)
  oStompClient:connect()

  IF ( oStompClient:isConnected() )

    oStompClient:publish( "/queue/hbstomp", "First  message." )
    oStompClient:publish( "/queue/hbstomp", "Second message." )
    oStompClient:publish( "/queue/hbstomp", "Third message." )
    
    oStompClient:subscribeTo( "/queue/hbstomp" )
    oStompClient:subscribeTo( "/queue/hbstomp" )
    oStompClient:subscribeTo( "/queue/hbstomp" )

    oStompClient:disconnect()
  ELSE
    OutStd( "Failed to connect.", hb_EOL() )
    OutStd( "Message: ", oStompClient:getErrorMessage(), hb_EOL() )
    ErrorLevel(1)
  ENDIF

  RETURN ( NIL )
