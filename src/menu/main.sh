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

MENU_MAIN="MAIN"

MENU_MAIN_BTN_RUN="Запустить"
MENU_MAIN_BTN_STOP="Остановить"
MENU_MAIN_BTN_SELECT="Выбрать"

###################################################################
#
#                         EXPORTED FUNCTIONS
#
###################################################################

function menu_main_show() {
    local msg=""

    configs_menu_set $MENU_MAIN

    case "$1" in
        $MENU_MAIN_BTN_RUN)
            msg=$(menu_main_run)
            ;;
        $MENU_MAIN_BTN_STOP)
            msg=$(menu_main_stop)
            ;;
        $MENU_MAIN_BTN_SELECT)
            menu_select_show
            return
            ;;
        *)
            msg="Добро пожаловать в главное меню"
            tgapi_photo_send "image.jpg"
            ;;
    esac

    local buttons=(
        $MENU_MAIN_BTN_RUN
        $MENU_MAIN_BTN_STOP
        "Выбрать"
    )
    IFS=""
    tgapi_btn_msg_send "<b>Main Menu</b>: $msg" ${buttons[@]}
}

function menu_main_run() {
    echo "Начало сборки."
}

function menu_main_stop() {
    echo "Остановка."
}