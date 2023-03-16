#!/bin/bash

. ./defs

echo $TMP/$(ts true)

sudo wg show | grep -P 'latest|allowed' | awk '
BEGIN{buff=""}
{
    fl=0;
    if($1=="allowed") buff=$3;
    if($1=="latest"){
        fl=1;
        buff=buff" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12
    }
    if(fl==1){
        print buff;
        buff="";
    }
}' | sed -r 's/(\/32,?)|( ago)//g'  > $TMP/$(ts true)-timelaps.log
