set(SRCROOT ${PROJECT_SOURCE_DIR}/Network)

# all source files
set(SRC
    ${SRCROOT}/Export.h
    ${SRCROOT}/Ftp.cpp
    ${SRCROOT}/FtpStruct.h
    ${SRCROOT}/Ftp.h
    ${SRCROOT}/Http.cpp
    ${SRCROOT}/HttpStruct.h
    ${SRCROOT}/Http.h
    ${SRCROOT}/IpAddress.cpp
    ${SRCROOT}/IpAddress.h
    ${SRCROOT}/Packet.cpp
    ${SRCROOT}/PacketStruct.h
    ${SRCROOT}/Packet.h
    ${SRCROOT}/SocketSelector.cpp
    ${SRCROOT}/SocketSelectorStruct.h
    ${SRCROOT}/SocketSelector.h
    ${SRCROOT}/TcpListener.cpp
    ${SRCROOT}/TcpListenerStruct.h
    ${SRCROOT}/TcpListener.h
    ${SRCROOT}/TcpSocket.cpp
    ${SRCROOT}/TcpSocketStruct.h
    ${SRCROOT}/TcpSocket.h
    ${SRCROOT}/Types.h
    ${SRCROOT}/UdpSocket.cpp
    ${SRCROOT}/UdpSocketStruct.h
    ${SRCROOT}/UdpSocket.h
)

source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-network OBJECT ${SRC})
