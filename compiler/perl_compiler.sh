#!/bin/bash

FILE=$1
LEVEL=$2

LSET=""
if [ ! -z "$LEVEL" ]; then
    LSET="-$LEVEL"
fi

RCFILE=~/.perlcriticrc

# Find most appropriate .perlcriticrc file
path=$(dirname $FILE)
while [[ $path != / ]]; do
    if [[ -e "$path/.perlcriticrc" ]]; then
        RCFILE=$path/.perlcriticrc
        break
    fi
    path=$(readlink -f "$path/../")
done

perl -wc $FILE 2>&1 && perlcritic -p $RCFILE $LSET -verbose '%f:%l:%c:%m - %p\n' $FILE
