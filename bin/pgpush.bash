#!/bin/bash

HOST=host.urx.su
PORT=5015
DB=wguard
USER=wgdump

# ---------------------------------------------------------------------
HOME=`pwd`

[ -f ./defs ] && . ./defs
[ -f ../defs ] && cd .. && . ./defs && cd $HOME

[ -f $TMP/dump.pid ] && exit
touch $TMP/dump.pid

cd $TMP
mkdir -p $TMP/run
mv *dump.log $TMP/run

cd $TMP/run
ls *dump.log | while read a; do
    #TS=${a/-dump.log/}
    TS=${a:0:10}' '${a:11:2}':'${a:14:2}':'${a:17:2}
    DUMP=`cat $a | awk '{gsub(/^[ \s]/, "", $0);print $0"^";}'`

    echo "insert into wgdump.dump(ts,dump) values('"$TS"','"$DUMP"');" > $TMP/tmp.sql
    psql -h $HOST -p $PORT -d $DB -U $USER -w -q  -v ON_ERROR_STOP=1 -f $TMP/tmp.sql
    #psql -h $HOST -p $PORT -d $DB -U $USER -w -q  -v ON_ERROR_STOP=1 -c "insert into wgdump.dump(ts,dump) values('"$TS"','"$DUMP"');"

    ERRCODE=$?
    #echo 'ERRORCODE='$ERRCODE
    if [ $ERRCODE == 1 ]; then
        echo 'ret=1'
    else
        echo 'ret='$ERRCODE
        rm -f $a
    fi
done
cd $HOME

rm -f $TMP/tmp.sql
rm -f $TMP/dump.pid
