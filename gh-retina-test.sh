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


_get_avatar_url ()
{
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


_user_pfp ()
{
  echo "kitty +kitten icat --align left "$avatar_url""
}


_main ()
{
  paste -d " " <(echo -e "${_user_pfp}") <(gh api "user" | _print_info)
}

_get_value ()
{
  jq -r ".${1}" </dev/stdin
}

_get_user_info ()
{
  local username="$1"
  gh api "users/$username"
}

_print_info ()
{
  local userinfo
  userinfo="$(cat /dev/stdin)"

  echo -e "\n"
  echo -e "${COLOR_BG_BLACK} $(_get_value "login" <<< "${userinfo}") ${COLOR_NONE}"

  echo -e ""

  _get_value "bio" <<< ${userinfo}

  _print_bar 

  for k in "${JSON_KEYS[@]}"; do
        echo -e "${COLOR_FG_HIGHLIGHT} ${k} ${COLOR_NONE}${INDICATOR} $(_get_value "${k}" <<<"${userinfo}")"
    done

  _print_bar 

  _print_color_bar
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



_main "${@}"
exit "${?}"
