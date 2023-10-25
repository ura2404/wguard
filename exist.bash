#!/bin/bash

##
 # Посмотреть существующего пользователя
 # и перегенарция qr
 #

CLIENT=$1

[ -z $CLIENT ] && exit

. bin/client.bash $CLIENT


