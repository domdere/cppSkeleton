IF ( PION_STATIC )
    ADD_LIBRARY ( pion
        admin_rights.cpp
        algorithm.cpp
        http_auth.cpp
        http_basic_auth.cpp
        http_cookie_auth.cpp
        http_message.cpp
        http_parser.cpp
        http_plugin_server.cpp
        http_reader.cpp
        http_server.cpp
        http_types.cpp
        http_writer.cpp
        logger.cpp
        plugin.cpp
        process.cpp
        scheduler.cpp
        spdy_decompressor.cpp
        spdy_parser.cpp
        tcp_server.cpp
        tcp_timer.cpp
    )
ELSE ( PION_STATIC )

    ADD_LIBRARY ( pion SHARED
        admin_rights.cpp
        algorithm.cpp
        http_auth.cpp
        http_basic_auth.cpp
        http_cookie_auth.cpp
        http_message.cpp
        http_parser.cpp
        http_plugin_server.cpp
        http_reader.cpp
        http_server.cpp
        http_types.cpp
        http_writer.cpp
        logger.cpp
        plugin.cpp
        process.cpp
        scheduler.cpp
        spdy_decompressor.cpp
        spdy_parser.cpp
        tcp_server.cpp
        tcp_timer.cpp
    )
ENDIF ( PION_STATIC )

TARGET_LINK_LIBRARIES ( pion 
    ${LOG4CPLUS_LIBRARIES}
    )
