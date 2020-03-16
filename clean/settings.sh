#!/bin/bash

# Absolute import
. $(dirname $(realpath $0))/helpers.sh

SCRIPT_NAME='clean'

SHORT_OPTS='efnsx'
LONG_OPTS='elf,force,help,no-exe,script,exe'
HELP="Try '$SCRIPT_NAME --help' for more information."

TRASH=()  # for files to be removed.

# Each flag is either ON (1) or OFF (0).
declare -A FLAGS=(
    [elf]=0      # -e, --elf
    [default]=1
    [force]=0    # -f, --force
    [no-exe]=0   # -n, --no-exe
    [script]=0   # -s, --script
    [exe]=0      # -x, --exe
)

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HELP" >&2
    exit 1
fi

eval set -- "$ARGV"

while true; do
    case $1 in
        -e | --elf)
            FLAGS[default]=0
            FLAGS[elf]=1
            ;;
        -f | --force)
            FLAGS[force]=1 ;;
        --help)
            usage
            exit 0
            ;;
        -n | --no-exe)
            FLAGS[default]=0
            FLAGS[no-exe]=1
            ;;
        -s | --script)
            FLAGS[default]=0
            FLAGS[script]=1
            ;;
        -x | --exe)
            FLAGS[default]=0
            FLAGS[exe]=1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

# Default settings.
if [[ ${FLAGS[default]} -eq 1 ]]; then
    FLAGS[elf]=1
fi
