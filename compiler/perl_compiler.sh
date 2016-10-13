#!/bin/bash

FILE=$1
LEVEL=$2

LSET=""
if [ ! -z "$LEVEL" ]; then
    LSET="-$LEVEL"
fi

perl -wc $FILE 2>&1 && perlcritic $LSET -verbose '%f:%l:%c:%m - %p\n' $FILE
