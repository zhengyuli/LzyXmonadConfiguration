#!/bin/bash

#---------------------------------------------------------------------------------
# Name: wallpaper.sh
# Purpose: Wallpaper installation
#
# Time-stamp: <2014-03-26 15:24:53 Wednesday by lzy>
#
# Author: zhengyu li
# Created: 2014-03-26
#
# Copyright (c) 2014 zhengyu li <lizhengyu419@gmail.com>
#---------------------------------------------------------------------------------

source /etc/profile
export LC_ALL=C  

shopt -s nullglob

cd $HOME/.WallPaper

while true; do
    files=()
    for i in *.jpg *.png *.jpeg; do
        [[ -f $i ]] && files+=("$i")
    done
    range=${#files[@]}
    ((range))

    file="${files[RANDOM % range]}"
    feh --bg-scale "${files[RANDOM % range]}"

    sleep 5m
done
