#!/bin/bash

############################## Variables  ################

DIRECTORIES=$(find . -mindepth 1 -maxdepth 1 -type d | sed  '/build/d; /\.git/d  ')
FLAGS="arch gen"
WARNING_FILE=warning.txt


source .env

dir-files() {
    file="$1/$1"
    if [ -f  $file ]
    then
        echo $file
    fi

    for flag in $FLAGS
    do
        file="$1/$1.$flag"
        if [ -f $file ]
        then
            echo $file
        fi
    done
}

concat() {
    if [ -e "$1/comment" ]
    then
        COMMENT="$(cat $1/comment)"
    else
        COMMENT="#"
    fi
    export COMMENT

    target="build/$1"

    if [ -f $target ]
    then
        mv $target "$target.$(date -Ihours).bak"
    fi

    cat $WARNING_FILE $(dir-files "$1") | envsubst > $target
}

############################## Prepare ##################

mkdir -p build

for dir in $DIRECTORIES
do
    echo "Build configuration for $dir"
    concat $dir
done



######################### Run Linker #####################

./linker.sh Xresources ~/.Xresources /usr/lib/Xorg
./linker.sh termite ~/.config/termite/config /usr/bin/termite
