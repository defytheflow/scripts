#!/bin/bash

SHORT_OPTS="efhlm:"
LONG_OPTS="edit,force,help,lesson,make:"
HELP_MSG="Try: 'new -h | --help' for more information"

# Default templates must reside in this directory.
TEMPLATES_DIR_NAME="$(dirname $(realpath $0))/templates"

# Names of supported makefiles
SUPPORTED_MAKEFILES=(c-project c-shared cpp-project)
MAKEFILE_NAME="Makefile"

declare -A FLAGS=(
    [edit]=0    # -e, --edit
    [force]=0   # -f, --force
    [lesson]=0  # -l, --lesson
    [make]=""   # -m, --make
)

# Line numbers where cursor should appear if --edit flag is on.
declare -A CURSOR_LINE_NUMBERS=(
    [c]=5
    [cpp]=8
    [html]=12
    [py]=6
)

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HELP_MSG" >&2
    exit 1
fi

eval set -- "$ARGV"

. $(dirname $(realpath $0))/helpers.sh

while true; do
    case $1 in
        -e | --edit)
            FLAGS[edit]=1   ;;
        -f | --force)
            FLAGS[force]=1  ;;
        -h | --help)
            usage
            exit 0          ;;
        -l | --lesson)
            FLAGS[lesson]=1 ;;
        -m | --make)
            shift
            if ! makefile_supported "$1"; then
                echo "Error: '$1' makefile is not supported." >&2
                echo "Supported makefiles: ${SUPPORTED_MAKEFILES[@]}" >&2
                echo "$HELP_MSG" >&2
                exit 1
            fi
            FLAGS[make]=$1 ;;
        --)
            shift
            break          ;;
    esac
    shift
done
