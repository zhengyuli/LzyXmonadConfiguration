#!/bin/bash

#---------------------------------------------------------------------------------
# Name: single-screen.sh
# Purpose:
#
# Time-stamp: <2014-03-26 15:16:35 Wednesday by lzy>
#
# Author: zhengyu li
# Created: 2014-03-26
#
# Copyright (c) 2014 zhengyu li <lizhengyu419@gmail.com>
#---------------------------------------------------------------------------------

source /etc/profile
export LC_ALL=C  

rm -rf ~/.xmonad/xmonad* 
cp -f ~/.xmonad/backup/xmonad.hs ~/.xmonad/xmonad.hs

pkill -9 trayer
trayer --edge top --align right --SetDockType true --expand true --width 7 --transparent true --tint 0x000000 --alpha 0 --height 21&

xmonad --restart
