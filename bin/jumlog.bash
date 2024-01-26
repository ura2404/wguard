#!/bin/bash

##
 # Сжать логи wg за вчерашний день
 #

# ---------------------------------------------------------------------
HOME=`pwd`

[ -f ./defs ] && . ./defs
[ -f ../defs ] && cd .. && . ./defs && cd $HOME

#YESTERDAY=$(date +"%Y-%m-%d")
YESTERDAY=$(date +"%Y-%m-%d" -d "yesterday")

BACKUP_FOLDER=$BACKUP/log/$YESTERDAY

if [ -d $BACKUP_FOLDER ]; then
    cd $BACKUP/log
    tar -cjf $YESTERDAY.bz2 $YESTERDAY
    rm -dr $BACKUP_FOLDER
    cd $HOME
fi
