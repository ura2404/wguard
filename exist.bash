#!/bin/bash

CLIENT=$1

[ -z $CLIENT ] && exit

. bin/client.bash $CLIENT


