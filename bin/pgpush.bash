#!/bin/bash

HOST=host.urx.su
PORT=5015
DB=wguard
USER=wgdump
SRV=wg.urx.su

# ---------------------------------------------------------------------
HOME=`pwd`

[ -f ./defs ] && . ./defs
[ -f ../defs ] && cd .. && . ./defs && cd $HOME

[ -f $TMP/dump.pid ] && exit
touch $TMP/dump.pid      # --- pid файл этого обработчика

cd $TMP
mkdir -p $TMP/run                            # --- папка для логов для обработки
mkdir -p $TMP/log                            # --- папка лога работы этого скрипта
mkdir -p $BACKUP/log/$(date +"%Y-%m-%d")     # --- папка backup лога wg

mv *dump.log $TMP/run    # --- перенести логи для обработки

# --- перебрать логи wg
cd $TMP/run
ls *dump.log | while read a; do
    # --- 
    #TS=${a/-dump.log/}
    TS=${a:0:10}' '${a:11:2}':'${a:14:2}':'${a:17:2}

    # --- заменить \n -> ^
    DUMP=`cat $a | awk '{gsub(/^[ \s]/, "", $0);print $0"^";}'`

    # --- формировать sql для базы и выполнить его
    echo "insert into wgdump.dump(ts,server,dump) values('"$TS"','"$SRV"','"$DUMP"');" > $TMP/tmp.sql
    psql -h $HOST -p $PORT -d $DB -U $USER -w -q  -v ON_ERROR_STOP=1 -f $TMP/tmp.sql >> $TMP/log/dump.log 2>&1
    #psql -h $HOST -p $PORT -d $DB -U $USER -w -q  -v ON_ERROR_STOP=1 -c "insert into wgdump.dump(ts,dump) values('"$TS"','"$DUMP"');"

    # --- обработать ошибку
    ERRCODE=$?
    #echo 'ERRORCODE='$ERRCODE
    if [ $ERRCODE == 0 ]; then
        echo 'OK' 
        #rm -f $a
        mv $a $BACKUP/log/$(date +"%Y-%m-%d")
    else
        echo 'ERRORCODE='$ERRCODE | tee -a $TMP/log/dump.log
    fi
done
cd $HOME

rm -f $TMP/tmp.sql
rm -f $TMP/dump.pid
