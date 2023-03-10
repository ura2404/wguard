#!/bin/bash

. ./defs

CLIENT=$1
NET=$NET1

echo ''

[ ! -n "$CLIENT" ] && echo 'Client name not define' && return

if [ "$CLIENT" == "next" ]; then
    [ ! -n "$NET" ]    && echo 'Network not define' && return
    CLIENT=$(next_client)
    IP=$(next_ip $NET)

    echo Client=$CLIENT Net=$NET IP=$IP
    echo ''
    generate $CLIENT $NET $IP
    server $CLIENT
    qr $CLIENT
else
    echo Client=$CLIENT
    echo ''
    qr $CLIENT
fi

#echo $CLIENT $NET $IP

#generate $CLIENT $NET $IP#						\
#    && (echo 'Клиент создан'     && echo && qr $CLIENT)		\
#    || (echo 'Клиент существует' && echo && qr $CLIENT)

#next_client
