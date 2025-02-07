#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-06

suffix=$(date +%Y%m%d)

for f in $(find /data/ -type f -name "*.txt");do
    echo "备份文件$f"
    cp "${f}" "${f}_${suffix}"
done