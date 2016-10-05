#!/bin/sh

FILE=$1

perl -wc $FILE 2>&1 && perlcritic -verbose '%f:%l:%c:%m - %p\n' -3 $FILE
