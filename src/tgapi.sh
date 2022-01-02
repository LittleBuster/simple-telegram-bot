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

###################################################################
#
#                         EXPORTED FUNCTIONS
#
###################################################################

function tgapi_photo_send() {
    curl --silent -F photo=@"$1" \
            https://api.telegram.org/bot$CFG_BOT_ID/sendPhoto?chat_id=$G_CHAT_ID 1> /dev/null
}

function tgapi_msg_send() {
    curl --silent -X POST \
        -d chat_id=$1 \
        -d parse_mode="HTML" \
        -d text="$2" \
        https://api.telegram.org/bot$CFG_BOT_ID/sendMessage 1> /dev/null
}

function tgapi_btn_msg_send() {
    local out=""
    btns=("$@")
    unset btns[0]

    for item in "${btns[@]}"
    do
        out+="[\"$item\"],"
    done
    out=${out:0:${#out}-1}

    curl --silent -X POST \
        -d chat_id="$G_CHAT_ID" \
        -d parse_mode="HTML" \
        -d text="$1" \
        -d reply_markup="{\"keyboard\":[$out]}" \
        https://api.telegram.org/bot$CFG_BOT_ID/sendMessage 1> /dev/null
}

function tgapi_lastmsg_get() {
    curl --silent https://api.telegram.org/bot$CFG_BOT_ID/getUpdates | jq ".result[-1]"
}

function tgapi_offset_set() {
    curl --silent https://api.telegram.org/bot$CFG_BOT_ID/getUpdates?offset=$1 1> /dev/null
}

###################################################################
#
#                         MESSAGE PROPERTIES
#
###################################################################

function tgapi_msg_text() {
    echo $1 | jq ".message.text" | tr -d \"
}

function tgapi_msg_upd() {
    echo $1 | jq ".update_id"
}

function tgapi_msg_chat() {
    echo $1 | jq ".message.chat.id"
}

function tgapi_msg_name() {
    echo $1 | jq ".message.from.first_name" | tr -d \"
}

function tgapi_msg_surname() {
    echo $1 | jq ".message.from.last_name" | tr -d \"
}
