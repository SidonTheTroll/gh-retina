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

function _display_profile_picture() {
    local username="$1"
    local avatar_url
    avatar_url="$(_get_avatar_url "$username")"

    if [ "$avatar_url" != "null" ]; then
        # Display the profile picture in Kitty terminal on the left
        kitty +kitten icat --align left "$avatar_url"
    else
        echo "User not found or has no profile picture."
    fi
}

function _print_info() {
    local username="$1"
    local userinfo
    userinfo="$(_get_user_info "$username")"

    local avatar_url
    avatar_url="$(_get_avatar_url "$username")"

    if [ "$avatar_url" != "null" ]; then
        # Display the profile picture in Kitty terminal on the left
        kitty +kitten icat --align left "$avatar_url"
    else
        echo "User not found or has no profile picture."
    fi

    echo -e "\n"

    # Get the terminal width
    local term_width
    term_width="$(tput cols)"

    # Calculate the width for the user info section
    local info_width
    info_width=$((term_width - 40))  # Adjust this value as needed

    # Create a string of spaces to center-align the user info
    local padding
    padding=""
    for ((i = 0; i < ((info_width - 1) / 2); i++)); do
        padding+=" "
    done

    _get_value "bio" <<<"$userinfo"

    _print_bar

    for k in "${JSON_KEYS[@]}"; do
        local value
        value="$(_get_value "${k}" <<<"$userinfo")"
        printf "%s${COLOR_FG_HIGHLIGHT} ${k} ${COLOR_NONE}${INDICATOR} ${value}\n" "$padding"
    done

    _print_bar
}

function _get_value() {
    jq -r ".${1}" </dev/stdin
}

function _print_bar() {
    echo -e "${COLOR_FG_BLACK}=================================================${COLOR_NONE}"
}

function _print_color_bar() {
    echo -e ""

    for i in "" ";1"; do
        for j in $(seq 0 7); do
            printf " \033[4${j}${i}m    \033[m"
        done
        echo -e "\n"
    done

    echo -e ""
}

function _main() {
    local username="$1"
    if [ -z "$username" ]; then
        # No username provided, get logged-in user's info
        username="$(gh auth status --username)"
    fi

    _display_profile_picture "$username"
    _print_info "$username"
}

_main "${@}"
exit "${?}"

