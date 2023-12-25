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

function _print_info() {
    local username="$1"
    local userinfo
    userinfo="$(_get_user_info "$username")"

    local avatar_url
    avatar_url="$(_get_avatar_url "$username")"

    if [ "$avatar_url" != "null" ]; then
        # Download the image
        local temp_image="/tmp/github_avatar.jpg"
        curl -s -o "$temp_image" "$avatar_url"

        # Resize the image to a smaller size
        convert "$temp_image" -resize 300x300 "$temp_image"

        # Display the resized image in Kitty terminal on the left
        kitty +kitten icat --align left "$temp_image"

        # Remove the temporary image file
        rm "$temp_image"
    else
        echo "User not found or has no profile picture."
    fi

    echo -e "\n"

    # Print the user's name inside a black box with cyan foreground
    echo -e "${COLOR_BG_BLACK}${COLOR_FG_HIGHLIGHT}\033[36m$(_get_value "name" <<<"${userinfo}")${COLOR_NONE}"

    _print_bar

    for k in "${JSON_KEYS[@]}"; do
        local value
        value="$(_get_value "${k}" <<<"$userinfo")"
        printf "%s${COLOR_FG_HIGHLIGHT}${k}${COLOR_NONE}${INDICATOR}${value}\n" ""
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
    read -p "Enter a GitHub username: " username
    _print_info "$username"
}

_main "${@}"
exit "${?}"
