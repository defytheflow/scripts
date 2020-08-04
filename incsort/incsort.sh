#!/bin/bash

function usage()
{
    printf "%b"                                                                \
    "Correct order of include directives in C/C++ source files.\n\n"           \
                                                                               \
    "Usage:\n"                                                                 \
    "  include-order [options] <file>...\n\n"                                  \
                                                                               \
    "Arguments:\n"                                                             \
    "  file      C/C++ source file.\n\n"                                       \
                                                                               \
    "Options:\n"                                                               \
    "  --help    display this message and exit.\n"
}

# ---------------------------------------------------------------------------- #
#                               Global Variables                               #
# ---------------------------------------------------------------------------- #

SCRIPT_NAME='include-order'

SHORT_OPTS='h'
LONG_OPTS='help'
HELP="Try '$SCRIPT_NAME --help' for more information."

INCLUDE_PATTERN="^\s*#include\s+[<\"]\w+\.h[>\"]\s*$"

ALL_INCLUDES=()           # array of <header.h>... "header.h"...
LOCAL_INCLUDES=()         # array of "header.h"...
SYSTEM_INCLUDES=()        # array of <stdlib.h>...
THIRD_PARTY_INCLUDES=()   # array of <third_party.h>...

THIRD_PARTY_INCLUDES_DIR='/usr/local/include'

FILE_TOTAL_LINE_COUNT=0
LAST_INCLUDE_LINE_NUM=0

# ---------------------------------------------------------------------------- #
#                                Parse Options                                 #
# ---------------------------------------------------------------------------- #

ARGV=$(getopt -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "$HELP" >&2
    exit 1
fi

eval set -- "$ARGV"

# ---------------------------------------------------------------------------- #
#                                Toggle Options                                #
# ---------------------------------------------------------------------------- #

while true; do
    case $1 in
        --help)
            usage
            exit 0 ;;
        --)
            shift
            break  ;;
    esac
    shift
done

# ---------------------------------------------------------------------------- #
#                                  Validation                                  #
# ---------------------------------------------------------------------------- #

# If no <file>:
if [[ $# -eq 0 ]]; then
    echo "$SCRIPT_NAME: missing <file> argument" >&2
    echo $HELP >&2
    exit 1
fi

# ---------------------------------------------------------------------------- #
#                                   Main Job                                   #
# ---------------------------------------------------------------------------- #

# For each <file>:
for file in $@; do

    # If <file> doesn't exist"
    if [[ ! -f "$file" ]]; then
        echo "$SCRIPT_NAME: file '$file' does not exits"
        continue
    fi

    # Extract all #includes.
    mapfile ALL_INCLUDES < <(grep -nE "$INCLUDE_PATTERN" "$file")
    # Remove '#include' words.
    ALL_INCLUDES=( "${ALL_INCLUDES[@]/\#include/}" )

    # If zero or only one include, just print the file the same.
    if [[ ${#ALL_INCLUDES[@]} -le 1 ]]; then
        cat $file
        continue
    fi

    # Count total lines in file.
    FILE_TOTAL_LINE_COUNT=$(wc -l $file | grep -Eo -- "[0-9]+")
    # Get the line number of last #include.
    LAST_INCLUDE_LINE_NUM=$(echo ${ALL_INCLUDES[-1]} | grep -Eo -- "[0-9]+")

    # Sort out local ("header.h") and system (<header.h>) includes.
    for include in ${ALL_INCLUDES[@]}; do
        if [[ $include == \"* ]]; then
            LOCAL_INCLUDES+=("$include")
        elif [[ $include == \<* ]]; then

            # Check if include is from THIRD_PARTY_INCLUDES directory
            is_third_party=0
            for third_party_include in $(ls "$THIRD_PARTY_INCLUDES_DIR"); do
                      # remove < >
                if [[ ${include:1:-1} == $third_party_include ]]; then
                    THIRD_PARTY_INCLUDES+=("$include")
                    is_third_party=1
                    break
                fi
            done

            # If include is not from THIRD_PARTY_INCLUDES directory
            if [[ $is_third_party -eq 0 ]]; then
                SYSTEM_INCLUDES+=("$include")
            fi
        fi
    done

    for include in ${LOCAL_INCLUDES[@]}; do
        # Remove "" and extension from include (e.g "header.h" -> header).
        include_name=$(basename ""${include:1:-1} .h)
        # Remove extension from file (e.g "source.c" -> source).
        file_name="${file%%.*}"
        # If header file has the same name as the source file print it first
        if [[ $include_name == $file_name ]]; then
            echo -e "#include $include\n"
            # Remove this include from local includes.
            LOCAL_INCLUDES=( ${LOCAL_INCLUDES[@]/$include/} )
            break
        fi
    done

    # Sort alphabetically local includes
    SORTED_LOCAL_INCLUDES=($(printf '%s\n' "${LOCAL_INCLUDES[@]}" | sort))
    # Sort alphabetically third_party includes
    SORTED_THIRD_PARTY_INCLUDES=($(printf '%s\n' "${THIRD_PARTY_INCLUDES[@]}" | sort))
    # Sort alphabetically system includes
    SORTED_SYSTEM_INCLUDES=($(printf '%s\n' "${SYSTEM_INCLUDES[@]}" | sort))

    # If have local includes -> print
    if [[ ${#SORTED_LOCAL_INCLUDES[@]} -gt 0 ]]; then
        printf '#include %s\n' "${SORTED_LOCAL_INCLUDES[@]}"; echo
    fi

    # If have third_party includes -> print
    if [[ ${#SORTED_THIRD_PARTY_INCLUDES[@]} -gt 0 ]]; then
        printf '#include %s\n' "${SORTED_THIRD_PARTY_INCLUDES[@]}"; echo
    fi

    # If have system includes -> print
    if [[ ${#SORTED_SYSTEM_INCLUDES[@]} -gt 0 ]]; then
        printf '#include %s\n' "${SORTED_SYSTEM_INCLUDES[@]}"; echo
    fi

    tail -$(( FILE_TOTAL_LINE_COUNT - LAST_INCLUDE_LINE_NUM )) "$file"

done

exit 0