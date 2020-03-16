#!/bin/bash

usage()
{
    printf "%b"                                                                \
    "Creates default templates for files.\n\n"                                 \
                                                                               \
    "Usage:\n"                                                                 \
    "  new [options] <file>...\n\n"                                            \
                                                                               \
    "Arguments:\n"                                                             \
    "  file                        name of the file to create.\n"              \
    "  type                        c, cpp\n\n"                                 \
                                                                               \
    "Options:\n"                                                               \
    "  -e, --edit                  open <file> for editing in vim.\n"          \
    "  -f, --force                 disable warnings.\n"                        \
    "  -h, --help                  display this message.\n"                    \
    "  -l, --lesson                generate a default lesson plan.\n"          \
    "  -m <type>, --make <type>    generate a default makefile of <type>.\n\n" \
                                                                               \
    "Examples:\n"                                                              \
    "  new hello                   create a file 'hello'.\n"                   \
    "  new hello.c                 create a default C template.\n"             \
    "  new -e hello                create a file 'hello' and open in vim\n"    \
    "  new -e hello.c              create a default C template file and\n"     \
    "                              open for editing in vim.\n\n"               \
                                                                               \
    "Author:\n"                                                                \
    "  Artyom Danilov\n\n"
}

# Absolute imports
. $(dirname $(realpath $0))/settings.sh
. $(dirname $(realpath $0))/helpers.sh

# Check that $TEMPLATES_DIR_NAME directory exists
if [[ ! -d "$TEMPLATES_DIR_NAME" ]]; then
    echo "Error: unable to find '$TEMPLATES_DIR_NAME' directory" >&2
    echo "Fix: create '$TEMPLATES_DIR_NAME' directory and fill it with your templates" >&2
    exit 1
fi

# -e, --edit option requires a <file>
if [[ ${FLAGS[edit]} -eq 1 ]]; then
    # Check if <file> argument was given
    if [[ $# -eq 0 ]]; then
        echo "Error: missing <file> argument" >&2
        echo "$HELP_MSG" >&2
        exit 1
    fi
fi

# -m, --make option doesn't require a <file>
if [[ -n ${FLAGS[make]} ]]; then
    # Check if no <file> arguments were given or <file> argument has an extension
    if [[ $# -eq 0 || "$1" =~ ^.+\..+$ ]]; then
        copy_template "makefiles/${FLAGS[make]}" "$MAKEFILE_NAME"
    else
        copy_template "makefiles/${FLAGS[make]}" "$1"
        shift
    fi
fi


# -l, --lesson option doesn't require a <file>
if [[ ${FLAGS[lesson]} -eq 1 ]]; then
    # Check if no <file> arguments were given or <file> argument has an extension
    if [[ $# -eq 0 || "$1" =~ ^.+\..+$ ]]; then
        copy_template lesson-plan $(date +"%d-%m-%y").txt
    else
        copy_template lesson-plan "$1"
        shift
    fi
fi

# If none of the file flags were used
if [[ -z ${FLAGS[make]} && ${FLAGS[lesson]} -eq 0 && ${FLAGS[edit]} -eq 0 ]]; then
    # Check if <file> argument was given
    if [[ $# -eq 0 ]]; then
        echo "Error: missing <file> argument" >&2
        echo "$HELP_MSG" >&2
        exit 1
    fi
fi

# If still have files to create
if [[ $# -gt 0 ]]; then

    # For each <file> argument
    for file in "$@"; do

        # Extract the root part of file
        root=${file%.*}

        # Extract the extension of file
        ext=${file#$root}
        ext=${ext:1}  # remove leading '.'

        case $ext in
            asm | c | cpp | html | py | s | sh)
                copy_template "$ext"  "$file"
                ;;
            *)
                touch "$file"
                ;;
        esac

    done

fi

if [[ ${FLAGS[edit]} -eq 1 ]]; then
    # Open one file for editing.
    if [[ $# -eq 1 ]]; then
        vim -c 'startinsert' "$1" "+${CURSOR_LINE_NUMBERS[$ext]}"
    # Open multiple files for editing.
    elif [[ $# -gt 1 ]]; then
        vim -c 'startinsert' -O "$@" "+${CURSOR_LINE_NUMBERS[$ext]}"
    fi
fi

exit 0
