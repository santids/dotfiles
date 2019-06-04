#!/bin/bash

############################## Variables  ################

DIRECTORIES=$(find . -mindepth 1 -maxdepth 1 -type d | sed  '/build/d; /\.git/d  ')
WARNING_FILE=warning.txt

source .env

OS_RELEASE="/etc/os-release"

if [ -e $OS_RELEASE ]
then
    source $OS_RELEASE
fi

FLAGS="$ID urxvt"

printf "Active Flags: $FLAGS\n\n"

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

substitute() {
    envsubst "$(printenv | sed -e 's/=.*//' -e 's/^/\$/g')"
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
    backup="build/backup/$1.$(date -Ihours).bak"

    if [ -f $target ]
    then
        mv $target $backup
    fi

    cat $WARNING_FILE $(dir-files "$1") | substitute > $target

}

############################## Prepare ##################

mkdir -p build
mkdir -p build/backup

for dir in $DIRECTORIES
do
    echo "Build configuration for $dir"
    concat $dir
done

echo



######################### Run Linker #####################

./linker.sh Xresources ~/.Xresources /usr/lib/Xorg
./linker.sh termite ~/.config/termite/config /usr/bin/termite
./linker.sh i3  ~/.i3/config  /usr/bin/i3
./linker.sh flake8 ~/.config/flake8 /usr/bin/flake8
./linker.sh aliases ~/.aliases /bin/bash
