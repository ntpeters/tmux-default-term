#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_terms_option="@default-terminals"

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value="$(tmux show-option -gqv "$option")"
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

main() {
    local terms="$(get_tmux_option "$default_terms_option" "")"
    for term in $terms; do
        # Check if this term type is listed in terminfo
        toe -a | grep "^${term}\s" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            tmux set -g default-terminal "$term"
            break
        fi
    done
}

main
