#!/bin/bash
#author: xili
#version: v1
#date: 2025-09-21

#判断参数长度
if [ $# -ne 1 ] || [ ${#1} -ne 8 ]
then
    echo "Usage: bash $0 yyyymmdd"
    exit 1
fi

mydate=$1

year=${mydate:0:4}
month=${mydate:4:2}
day=${mydate:6:2}

if cal $day $month $year >/dev/null 2>/dev/null
then
    echo "The date is OK. The date is $year年$month月$day日"
else
    echo "The date is Error."
fi