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
    echo $file
    if [ "$file" != "$2" ]
    then
        echo $file
        if [ !  -e $file ]
        then
            echo "$NOT_FOUND_MSG $file"
            exit 1
        fi
    fi
done

# Backup file if already exists
test -e "$2" && ( mv "$2" "$2.$(date -Iminutes).bak"; echo "$BACKUP_MSG $2")

# Link new file
ln -s build/$1 $2
