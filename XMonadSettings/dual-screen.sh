#!/bin/bash

#---------------------------------------------------------------------------------
# Name: dual-screen.sh
# Purpose:
#
# Time-stamp: <2014-03-26 15:27:34 Wednesday by lzy>
#
# Author: zhengyu li
# Created: 2014-03-26
#
# Copyright (c) 2014 zhengyu li <lizhengyu419@gmail.com>
#---------------------------------------------------------------------------------

source /etc/profile
export LC_ALL=C  

rm -rf ~/.xmonad/xmonad*
cp -f ~/.xmonad/backup/xmonad-dual-screen.hs ~/.xmonad/xmonad.hs

if xrandr|grep VGA1; then
    xrandr --output LVDS1 --auto --left-of VGA1
else
    xrandr --output LVDS1 --auto --left-of VGA2
fi

pkill -9 trayer
trayer --edge top --align right --SetDockType true --expand true --width 7 --transparent true --tint 0x000000 --alpha 0 --height 21&

xmonad --restart
