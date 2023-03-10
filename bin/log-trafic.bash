#!/bin/bash

. ./defs

sudo wg show | grep -P 'transfer:|allowed' | awk '
BEGIN{buff=""}
{
    fl=0;
    if($1=="allowed") buff=$3;
    if($1=="transfer:"){
        fl=1;
        buff=buff" "$2" "$3" "$5" "$6;
    }
    if(fl==1){
        print buff;
        buff="";
    }
}' | sed -r 's/\/32,?//g'  > $TMP/$(ts true)-trafic.log
