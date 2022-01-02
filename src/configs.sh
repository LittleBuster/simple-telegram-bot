#!/bin/bash

###################################################################
#
# Telegram Bot on Bash
#
# Copyright (C) 2021-2022 Sergey Denisov GPLv3
#
# Written by Sergey Denisov aka LittleBuster (DenisovS21@gmail.com)
#
###################################################################

CFG_BOT_ID=""
CFG_UPD_ID=""
CFG_MENU=""
CFG_ALLOW_USER=""
CFG_FILE="settings.cfg"

###################################################################
#
#                         EXPORTED FUNCTIONS
#
###################################################################

function configs_load() {
    if [ -f $1 ]
    then
        . $1
        CFG_BOT_ID=$TG_BOT
        CFG_UPD_ID=$TG_UPD_ID
        CFG_MENU=$TG_MENU
        CFG_ALLOW_USER=$TG_ALLOW_USER
    fi
}

function configs_save() {
    echo "TG_BOT=$CFG_BOT_ID" > $CFG_FILE
    echo "TG_UPD_ID=$CFG_UPD_ID" >> $CFG_FILE
    echo "TG_MENU=$CFG_MENU" >> $CFG_FILE
    echo "TG_ALLOW_USER=$CFG_ALLOW_USER" >> $CFG_FILE
}

function configs_menu_set() {
    CFG_MENU=$1
    configs_save
}

function configs_menu_get() {
    echo $CFG_MENU
}