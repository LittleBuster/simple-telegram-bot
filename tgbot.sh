#!/bin/bash

###################################################################
#
# Simple Telegram Bot
#
# Copyright (C) 2021 Sergey Denisov GPLv3
#
# Written by Sergey Denisov aka LittleBuster (DenisovS21@gmail.com)
#
###################################################################

###################################################################
#
#                        GLOBAL VARIABLES
#
###################################################################

BOT_ID=""
CHAT_ID=""
LAST_UPD_ID=""
CUR_MENU="MAIN"
SETTINGS="settings.cfg"

###################################################################
#
#                         GLOBAL FUNCTIONS
#
###################################################################

function configs_load() {
    if [ -f $1 ]
    then
        . $1
        BOT_ID=$TG_BOT
        LAST_UPD_ID=$TG_UPD_ID
        CUR_MENU=$TG_MENU
    fi
}

function configs_save() {
    echo "TG_BOT=$BOT_ID" > $SETTINGS
    echo "TG_UPD_ID=$LAST_UPD_ID" >> $SETTINGS
    echo "TG_MENU=$CUR_MENU" >> $SETTINGS
}

###################################################################
#
#                          MENU FUNCTIONS
#
###################################################################

function print_main_menu() {
    CUR_MENU="MAIN"
    configs_save

    local text=""

    case "$1" in
        '"Запустить"')
            text="Начало сборки"
            ;;
        '"Выбрать"')
            return $(print_select_menu)
            ;;
        *)
            text="Добро пожаловать в главное меню"
            ;;
    esac

    if [[ $1 != '"Запустить"' ]] ; then
        curl --silent -F photo=@"image.jpg" \
            https://api.telegram.org/bot$BOT_ID/sendPhoto?chat_id=$CHAT_ID 1> /dev/null
    fi

    curl --silent -X POST \
        -d chat_id=$CHAT_ID \
        -d parse_mode="HTML" \
        -d text="<b>BOT:</b> $text" \
        -d reply_markup='{"keyboard":[["Запустить"],["Выбрать"]]}' \
        https://api.telegram.org/bot$BOT_ID/sendMessage 1> /dev/null
}

function print_select_menu() {
    CUR_MENU="SELECT"
    configs_save

    case "$1" in
        '"Назад"')
            return $(print_main_menu)
            ;;
    esac

    curl --silent -X POST \
        -d chat_id=$CHAT_ID \
        -d parse_mode="HTML" \
        -d text="<b>BOT:</b> Выбор чего-либо" \
        -d reply_markup='{"keyboard":[["Назад"]]}' \
        https://api.telegram.org/bot$BOT_ID/sendMessage 1> /dev/null
}

###################################################################
#
#                        COMMANDS PROCESSOR
#
###################################################################

function process_cmd() {
    local text=$(echo $1 | jq ".message.text")

    echo "Incomming msg: $text"

    case $CUR_MENU in
        "MAIN")
            print_main_menu $text
            ;;
        "SELECT")
            print_select_menu $text
            ;;
    esac
}

###################################################################
#
#                         MAIN FUNCTIONS
#
###################################################################

function start_bot() {
    while :
    do
        local msg=$(curl --silent https://api.telegram.org/bot$BOT_ID/getUpdates | jq ".result[-1]")
        local upd_id=$(echo $msg | jq ".update_id")
        
        if [[ $upd_id != $LAST_UPD_ID ]] ; then
            LAST_UPD_ID=$upd_id
            CHAT_ID=$(echo $msg | jq ".message.chat.id")

            IFS=""
            process_cmd $msg
        fi

        sleep 1
    done
}

function main() {
    configs_load $SETTINGS
    start_bot
}

###################################################################
#
#                           SCRIPT START
#
###################################################################

main
