#!/bin/bash

#---------------------------------------------------------------------------------
# Name: install.sh
# Purpose: X11 and Xmonad configuration installation
#
# Time-stamp: <2014-07-23 17:05:09 Wednesday by lzy>
#
# Author: zhengyu li
# Created: 2014-03-26
#
# Copyright (c) 2014 zhengyu li <lizhengyu419@gmail.com>
#---------------------------------------------------------------------------------

source /etc/profile
export LC_ALL=C

BASE_DIR=$(cd $(dirname $0); pwd)

function packageNonExists()
{
    if which $1 >> /dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

echo "Please input OS type: (e.g. ubuntu, centos, fedora, mac)"
echo -n "OS Name: "
read OS_NAME
if [ -z $OS_NAME ]; then
    echo "OS Name can't be null."
    exit 1
fi

OS_NAME="$(echo $OS_NAME | tr '[A-Z]' '[a-z]')"
if [ $OS_NAME = "ubuntu" ]; then
    INSTALL_CMD="sudo apt-get install -y"
elif [ $OS_NAME = "centos" ]; then
    INSTALL_CMD="sudo yum install -y"
elif [ $OS_NAME = "mac" ]; then
    if packageNonExists brew ; then
        echo "Install brew for Mac OS"
        ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
        brew update
    fi
    INSTALL_CMD="brew install"
else
    echo "Unknown system name."
    exit 1
fi

# Install fonts
if [ ! -e /usr/share/fonts/myfonts ]; then
    sudo mkdir /usr/share/fonts/myfonts
    echo "install fonts... .. ."
    find $BASE_DIR/Fonts -name "*.ttf"|xargs -i sudo cp {} /usr/share/fonts/myfonts/ -v
    echo "waiting, flushing font cache..."
    sudo fc-cache -f -v
    echo "done, logout and see effect!"
fi

# Install mouse theme
echo "Installing mouse theme... .. ."
mkdir -p $HOME/.icons
rm $HOME/.icons/* -rf
sudo cp $BASE_DIR/CursorThemes/* /usr/share/icons/ -r
sudo rm /usr/share/icons/default -rf
sudo ln -s /usr/share/icons/Pulse-Glass /usr/share/icons/default
ln -s /usr/share/icons/Pulse-Glass $HOME/.icons/default

# Install wallpaper
echo "installing wallpaper"
if packageNonExists feh; then
    $INSTALL_CMD feh
fi
if [ ! -e $HOME/.WallPaper ]; then
    mkdir -p $HOME/.WallPaper
fi
cp $BASE_DIR/Backgrounds/src/* $HOME/.WallPaper -rv
sudo cp $BASE_DIR/Backgrounds/wallpaper.sh /usr/bin/ -v

# Install X11 configurations
echo "Installing Xdefaults and Xresources ... .. ."
if packageNonExists xsel; then
    $INSTALL_CMD xsel
fi
cp $BASE_DIR/TerminalSettings/Xdefaults $HOME/.Xdefaults -v
cp $BASE_DIR/TerminalSettings/Xdefaults $HOME/.Xresources -v
sudo cp $BASE_DIR/TerminalSettings/urxvt-perls/* /usr/lib/urxvt/perl/ -v

# Install xmonad
echo "Installing xmonad and xmobar configurations... .. ."
if packageNonExists xmonad; then
    if [ $OS_NAME = "centos" ] || [ $OS_NAME = "fedora" ]; then
        echo "ignore xmonad installation here, please intall it manually."
    else
        $INSTALL_CMD xmonad
        $INSTALL_CMD xmonad-contrib
        $INSTALL_CMD xmobar
        $INSTALL_CMD dmenu
        $INSTALL_CMD trayer
        $INSTALL_CMD xcompmgr
    fi
fi

if packageNonExists gnome-session; then
    cp $BASE_DIR/X11Settings/xinitrc $HOME/.xinitrc -v
else
    sudo cp $BASE_DIR/X11Settings/xmonad.desktop /usr/share/xsessions/ -v
fi
sudo cp $BASE_DIR/X11Settings/xmonad.start /usr/bin/ -v

if [ ! -e $HOME/.xmonad/backup ]; then
    mkdir -p $HOME/.xmonad/backup
fi

cp $BASE_DIR/XMonadSettings/xmobar.hs $HOME/.xmonad/xmobar.hs -v
cp $BASE_DIR/XMonadSettings/xmonad.hs $HOME/.xmonad/xmonad.hs -v
cp $BASE_DIR/XMonadSettings/xmonad.hs $HOME/.xmonad/backup/xmonad.hs -v
cp $BASE_DIR/XMonadSettings/xmonad-dual-screen.hs $HOME/.xmonad/backup/xmonad-dual-screen.hs -v

sudo cp $BASE_DIR/XMonadSettings/single-screen.sh /usr/bin/ -v
sudo cp $BASE_DIR/XMonadSettings/dual-screen.sh /usr/bin/ -v
