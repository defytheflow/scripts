#!/bin/sh

usage() {
    printf '%b'                                                                \
    'Create lists.\n\n'                                                        \
                                                                               \
    'Usage:\n'                                                                 \
    '  list [options]\n\n'                                                     \
                                                                               \
    'Options:\n'                                                               \
    '  -h, --help             display this message.\n'                         \
    '  -m, --mark             mark used in '-u' option.\n'                     \
    '  -o, --ordered          create an ordered list.\n'                       \
    '  -s, --sep              separator used in '-o' option.\n'                \
    '  -u, --unordered        create an unordered list.\n'
}

short_opts='hm:os:u'
long_opts='help,mark:,ordered,sep:,unordered'
help_msg="Try: '${0} -h' for more information"

declare -A OPTS=(
    [default]=1
    [mark]="-"
    [ordered]=0
    [sep]="."
    [unordered]=0
)

# parse options.
argv=$(getopt -o ${short_opts} -l ${long_opts} -- "$@")
if [ $? -ne 0 ]; then
    echo "${help_msg}" >&2
    exit 1
fi
eval set -- "${argv}"

# toggle options.
while true; do
    case ${1} in
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

list_ordered() {
  line_num=1
  while read -r line; do
    if [ -n "$line" ]; then
      echo "$line_num${OPTS[sep]} $line"
      line_num=$(( line_num + 1 ))
    else
      echo "${line}"
    fi
  done
}

list_unordered() {
  while read -r line; do
    if [ -n "$line" ]; then
      echo "${OPTS[mark]} $line"
    else
      echo "${line}"
    fi
  done
}

# default option.
if [ ${OPTS[default]} -eq 1 ]; then
    OPTS[ordered]=1
fi

# conflicting options.
if [ ${OPTS[ordered]} -eq 1 ] && [ ${OPTS[unordered]} -eq 1 ]; then
    echo "Error: '-o' and '-u' are conflicting options" >&2
    echo "${help_msg}" >&2
    exit 1

fi

if [ ${OPTS[ordered]} -eq 1 ]; then
    list_ordered
elif [ ${OPTS[unordered]} -eq 1 ]; then
    list_unordered
fi
