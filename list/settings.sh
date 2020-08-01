#!/bin/bash

# Settings for 'list.sh'

SHORT_OPTS="hm:os:u"
LONG_OPTS="help,mark:,ordered,sep:,unordered"
HLP_MSG="Try: 'list -h' for more information"

declare -A OPTS=(
    [default]=1
    [mark]="-"
    [ordered]=0
    [sep]="."
    [unordered]=0
)

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HLP_MSG" >&2
    exit 1
fi

eval set -- "$ARGV"

while true; do
    case $1 in

        -h | --help)
            usage
            exit 0            ;;

        -m | --mark)
            shift
            OPTS[mark]=$1     ;;

        -o | --ordered)
            OPTS[default]=0
            OPTS[ordered]=1   ;;

        -s | --sep)
            shift
            OPTS[sep]=$1      ;;

        -u | --unordered)
            OPTS[default]=0
            OPTS[unordered]=1 ;;

        --)
            shift
            break             ;;
    esac
    shift
done

if [[ ${OPTS[default]} -eq 1 ]]; then
    OPTS[ordered]=1
fi
