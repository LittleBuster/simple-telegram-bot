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

source src/configs.sh

MENU_SELECT="SELECT"

MENU_SELECT_BTN_BACK="Назад"
MENU_SELECT_BTN_CUT="Вырезать"

###################################################################
#
#                         EXPORTED FUNCTIONS
#
###################################################################

function menu_select_show() {
    local msg=""

    configs_menu_set $MENU_SELECT

    case "$1" in
        $MENU_SELECT_BTN_CUT)
            msg=$(menu_select_cut)
            ;;
        $MENU_SELECT_BTN_BACK)
            menu_main_show
            return
            ;;
        *)
            msg="Выбор чего-либо"
            ;;
    esac

    local buttons=(
        $MENU_SELECT_BTN_CUT
        $MENU_SELECT_BTN_BACK
    )
    IFS=""
    tgapi_btn_msg_send "<b>Select Menu</b>: $msg" ${buttons[@]}
}

function menu_select_cut() {
    echo "Вырезание."
}