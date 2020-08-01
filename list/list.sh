#!/bin/bash

usage()
{
    printf "%b"                                                                \
    "Create lists.\n\n"                                                        \
                                                                               \
    "Usage:\n"                                                                 \
    "  list [options]\n\n"                                                     \
                                                                               \
    "Options:\n"                                                               \
    "  -h, --help             display this message.\n"                         \
    "  -m, --mark             mark used in '-u' option.\n"                     \
    "  -o, --ordered          create an ordered list.\n"                       \
    "  -s, --sep              separator used in '-o' option.\n"                \
    "  -u, --unordered        create an unordered list.\n\n"                   \
                                                                               \
    "Author:\n"                                                                \
    "  Artyom Danilov\n\n"
}

# Absolute import
. $(dirname $(realpath $0))/settings.sh

list_ordered()
{
    local line_num=1

    while read line; do
        if [[ -n "$line" ]]; then
            echo "$line_num${OPTS[sep]} $line"
            line_num=$(( line_num + 1 ))
        else
            echo $line
        fi
    done
}

list_unordered()
{
    while read line; do
        if [[ -n "$line" ]]; then
            echo "${OPTS[mark]} $line"
        else
            echo $line
        fi
    done
}

# Conflicting options
if [[ ${OPTS[ordered]} -eq 1 && ${OPTS[unordered]} -eq 1 ]]; then
    echo "Error: '-o' and '-u' are conflicting options" >&2
    echo "$HLP_MSG" >&2
    exit 1

fi

if [[ ${OPTS[ordered]} -eq 1 ]]; then
    list_ordered
elif [[ ${OPTS[unordered]} -eq 1 ]]; then
    list_unordered
fi

exit 0
