#!/bin/bash

DIRECTORIES=$(find . -mindepth 1 -maxdepth 1 -type d | sed  '/build/d; /\.git/d  ')
FLAGS="arch gen"


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
    cat $(dir-files "$1") > "build/$1"
}

for dir in $DIRECTORIES
do
    concat $dir
done



