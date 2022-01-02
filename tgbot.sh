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

source src/global.sh
source src/configs.sh
source src/tgapi.sh
source src/menu/main.sh
source src/menu/select.sh

###################################################################
#
#                         GENERAL FUNCTIONS
#
###################################################################

function process_msg() {
    IFS=""
    local text=$(tgapi_msg_text $4)

    echo "Сообщение от $1 $2 ($3): $text"

    case $(configs_menu_get) in
        $MENU_MAIN)
            menu_main_show $text
            ;;
        $MENU_SELECT)
            menu_select_show $text
            ;;
    esac
}

function start_bot() {
    while :
    do
        IFS=""
        local msg=$(tgapi_lastmsg_get)
        local upd_id=$(tgapi_msg_upd $msg)

        if [[ $upd_id != $CFG_UPD_ID ]] ; then
            CFG_UPD_ID=$upd_id

            IFS=""
            local cur_id=$(tgapi_msg_chat $msg)
            local name=$(tgapi_msg_name $msg)
            local surname=$(tgapi_msg_surname $msg)

            if [[ $cur_id == $CFG_ALLOW_USER ]] ; then
                G_CHAT_ID=$cur_id
                process_msg $name $surname $cur_id $msg
            else
                tgapi_msg_send $cur_id "Доступ заблокирован."
                echo "Доступ для $name $surname ($cur_id) заблокирован."
            fi

            tgapi_offset_set $CFG_UPD_ID
        fi

        sleep 1
    done
}

function print_help() {
    echo "Параметры:"
    echo "  -c <CFG_FILE>   Открыть скрипт с указанным конфигурационным файлом"
    echo "  -h              Информация о параметрах"
}

###################################################################
#
#                          MAIN FUNCTION
#
###################################################################

function main() {
    while [ -n "$1" ]
    do
        case $1 in
            -c)
                CFG_FILE=$2
                shift
                ;;
            -h)
                print_help
                exit 0
                ;;
            *)
                echo "Нет такого параметра: $1"
                print_help
                ;;
        esac
        shift
    done

    configs_load $CFG_FILE
    start_bot
}

###################################################################
#
#                           SCRIPT START
#
###################################################################

main $@
