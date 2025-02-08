#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-14

echo "cmd meau ** 1-date 2-ls 3-who 4-pwd"

while true:
do
    read -p "please input a number 1-4: " n
    case $n in
        1)
            date
            break
            ;;
        2)
            ls
            break
            ;;
        3)
            who
            break
            ;;
        4)
            pwd
            break
            ;;
        *)
            echo "Wrong input, try again!"
            ;;
    esac
done