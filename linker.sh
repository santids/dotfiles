#!/bin/bash


# $1 Source File
# $2 Target File
# $3 Dependencies

NOT_FOUND_MSG="No se econtro el archivo:"
BACKUP_MSG="File found, backing up:"


if (($# < 2  ))
then
    echo "Not enough parameters"
    exit 1
fi


for file in $*
do
    if [ "$file" == "$1" ]
    then
        file="build/$1"
    fi
    if [ "$file" != "$2" ]
    then
        if [ !  -e $file ]
        then
            echo "$NOT_FOUND_MSG $file"
            exit 1
        fi
    fi
done

# Backup file if already exists

target="$(realpath build/$1)"

if [ -L "$2" ]
then
    source="$(readlink $2)"
    if [ $source != $target  ]
    then
        echo "Removing link $2 -> $source "
        rm $2
    else
        echo "Link $2 already set :)"
        exit 0
    fi
elif [ -f "$2" ]
then
    echo "$BACKUP_MSG $2"
    mv "$2" "$2.$(date -Ihours).bak"
fi

# Make directory if needed

destdir="$(dirname $2)"

if [ ! -d $destdir ]
then
    echo "Making directory"
    mkdir -p $destdir
fi

# Link new file
echo "Linking file.. $target to $2"
ln -s  $target $2
