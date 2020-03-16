#!/bin/bash

SCRIPT_NAME='new'  # used in error messages

SHORT_OPTS='efm:'
LONG_OPTS='edit,force,help,make:'
HELP="Try '$SCRIPT_NAME --help' for more information."

# Default templates must be in this directory.
TEMPLATES_DIR="$(dirname $(realpath $0))/templates"

MAKEFILE_NAME='Makefile'
MAKEFILE_TYPES=(c-project c-shared cpp-project)

# Each flag is either ON (1) or OFF (0).
declare -A FLAGS=(
    [edit]=0    # -e, --edit
    [force]=0   # -f, --force
)

# Each option has a string argument.
declare -A OPTS=(
    [make]=''   # -m, --make
)

# Line numbers where cursor should appear if --edit flag is on.
declare -A CURSOR_LINE_NUMBERS=(
    [c]=5
    [cpp]=8
    [html]=12
    [py]=6
)

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

# If error during parsing in getopt appeared.
if [[ $? -ne 0 ]]; then
    echo "$HELP" >&2
    exit 1
fi

eval set -- "$ARGV"

# Absolute import helpers.sh
. $(dirname $(realpath $0))/helpers.sh

while true; do
    case $1 in
        -e | --edit)
            FLAGS[edit]=1
            ;;
        -f | --force)
            FLAGS[force]=1
            ;;
        --help)
            usage
            exit 0
            ;;
        -m | --make)
            shift
            if ! makefile_supported "$1"; then
                echo "$SCRIPT_NAME: invalid argument '$1' for '--make'" >&2
                echo 'Valid arguments are:'
                printf "  - '%s'\n" "${MAKEFILE_TYPES[@]}"
                echo "$HELP" >&2
                exit 1
            fi
            OPTS[make]="$1"
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done
