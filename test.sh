#!/bin/sh

if [ -n "`grep -e '^dog-walk$' ./a.txt`" ]
then
    printf "YES!\n"
else
    printf "NO!\n"
fi
