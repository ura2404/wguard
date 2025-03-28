#!/bin/bash

function num {
    cat /var/tmp/wgdump-$1 | awk '{
    if ( match($3, /second/) || ( match($3, /minute/) && int($2) <= 3 )) print $0
    }' | wc -l
}

w0=`num wg0`
w1=`num wg1`
echo "Online $((w0 + w1))"
