#!/bin/bash

set -o nounset
set -o errexit

readonly COLOR_BG_BLACK="\033[40;1m"
readonly COLOR_FG_BLACK="\033[30m"
readonly COLOR_FG_HIGHLIGHT="\033[34;1m"
readonly COLOR_NONE="\033[m"
readonly INDICATOR="➤"

readonly JSON_KEYS=(
    "company"
    "blog"
    "location"
    "email"
    "twitter_username"
    "public_repos"
    "public_gists"
    "followers"
    "following"
    "created_at"
    "updated_at"
)

function _get_user_info() {
    local username="$1"
    gh api "users/$username"
}

function _get_avatar_url() {
    local username="$1"
    local avatar_url
    avatar_url="$(_get_user_info "$username" | jq -r .avatar_url)"
    echo "$avatar_url"
}

_main "${@}"
exit "${?}"
