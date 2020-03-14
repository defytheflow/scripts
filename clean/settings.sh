#!/bin/bash

SHORT_OPTS=":bfhnsx"
HELP_MSG="Try: 'clean -h' for more information"

TRASH=()

declare -A FLAGS=(
    [exec]=0     # -x
    [bin]=0      # -b
    [default]=1
    [force]=0    # -f
    [no_exec]=0  # -n
    [script]=0   # -s
)

ARGV=$(getopt -o $SHORT_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HELP_MSG" >&2
    exit 1
fi

eval set -- "$ARGV"

while true; do
    case $1 in
        -b)
            FLAGS[default]=0
            FLAGS[bin]=1   ;;
        -f)
            FLAGS[force]=1 ;;
        -h)
            usage
            exit 0 ;;
        -n)
            FLAGS[default]=0
            FLAGS[no_exec]=1 ;;
        -s)
            FLAGS[default]=0
            FLAGS[script]=1 ;;
        -x)
            FLAGS[default]=0
            FLAGS[exec]=1   ;;
        --)
            shift
            break           ;;
    esac
    shift
done

if [[ ${FLAGS[default]} -eq 1 ]]; then
    FLAGS[bin]=1
fi

