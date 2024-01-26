#!/bin/bash

## 
 # Формирование log-файла 
 #

. ./defs

echo $TMP/$(ts true)

sudo wg show all dump  > $TMP/$(ts true)-dump.log
