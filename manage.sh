#!/usr/bin/env bash
# 
# Dotfiles manager
#


# Logging mechanism
log_info() { printf "${BLUE}${BOLD}[-]${NORMAL} $1\n"; }
log_warn() { printf "${YELLOW}${BOLD}[+]${NORMAL} $1\n" >&2; }
log_erro() { printf "${RED}${BOLD}[!]${NORMAL} $1\n" >&2; }
log_succ() { printf "${GREEN}${BOLD}[*]${NORMAL} $1\n"; }


# paths definitions
wd=$(basename $(readlink -f $0))
dirs=(
    # Desktop environment
    [".config/i3"]
    ".config/kitty"
    ".config/compton"
    ".config/polybar"
    ".config/gtk-3.0"
    ".Xresources"
    # Shell
    ".zshrc"
    ".xonshrc"
)

declare -A fpaths
for d in ${dirs[@]};
do
    ["$wd/$d"]="$HOME/$d";
done



usage() {
    # Usage help message
    local USG_MSG=$(cat << EOF
Usage: manager.sh COMMAND [OPTIONS]

A simple dotfiles manager.

Available commands:
    ${BOLD}deploy${NORMAL}          Deploy the dotfiles
    ${BOLD}stop${NORMAL}            Restore the configuration before deployment
    ${BOLD}help${NORMAL}            Print this message
EOF
)

    echo "$USG_MSG"
}

deploy() {
    fpaths=(for p in ${paths[@]}; do realpath ~/$p; done)
    for p in ${fpaths[@]};
    do
        ln -s ${fpaths[@]}
    done
}

restore() {

}

main() {
    # Use colors only if available
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        NORMAL=`tput sgr0`
        RED=`tput setaf 1`
        GREEN=`tput setaf 2`
        YELLOW=`tput setaf 3`
        BLUE=`tput setaf 4`
        BOLD=`tput bold`
        DIM=`tput dim`
    else
        NORMAL=""
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        DIM=""
    fi

    # Set "exit on error" after color test
    set -o errexit

    # Parse command
    case "$1" in
        deploy ) shift; run $@ ;;
        restore ) shift; stop $@ ;;
        help | -h | --help ) usage ;;
        * ) log_erro "Unknown command: $@"; usage ;;
    esac

}

main $@
