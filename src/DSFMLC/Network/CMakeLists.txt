set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/Network)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/Network)


# all source files
set(SRC
    ${INCROOT}/Export.h
    ${INCROOT}/Err.h
    ${SRCROOT}/Err.cpp
    ${SRCROOT}/Ftp.cpp
    ${SRCROOT}/FtpStruct.h
    ${INCROOT}/Ftp.h
    ${SRCROOT}/Http.cpp
    ${SRCROOT}/HttpStruct.h
    ${INCROOT}/Http.h
    ${SRCROOT}/IpAddress.cpp
    ${INCROOT}/IpAddress.h
    ${SRCROOT}/Packet.cpp
    ${SRCROOT}/PacketStruct.h
    ${INCROOT}/Packet.h
    ${SRCROOT}/SocketSelector.cpp
    ${SRCROOT}/SocketSelectorStruct.h
    ${INCROOT}/SocketSelector.h
    ${SRCROOT}/TcpListener.cpp
    ${SRCROOT}/TcpListenerStruct.h
    ${INCROOT}/TcpListener.h
    ${SRCROOT}/TcpSocket.cpp
    ${SRCROOT}/TcpSocketStruct.h
    ${INCROOT}/TcpSocket.h
    ${INCROOT}/Types.h
    ${SRCROOT}/UdpSocket.cpp
    ${SRCROOT}/UdpSocketStruct.h
    ${INCROOT}/UdpSocket.h
)

source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-network OBJECT ${SRC})
