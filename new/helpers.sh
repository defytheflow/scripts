#!/bin/bash

# Display usage message.
function usage()
{
    printf "%b"                                                                \
    "Create default templates for files.\n\n"                                  \
                                                                               \
    "Usage:\n"                                                                 \
    "  new [options] <filename>...\n\n"                                        \
                                                                               \
    "Arguments:\n"                                                             \
    "  filename               name of the file to create.\n\n"                 \
                                                                               \
    "Options:\n"                                                               \
    "  -e, --edit         open <filename>s for editing in vim.\n"              \
    "  -f, --force        disable warnings.\n"                                 \
    "      --help         display this message and exit.\n"                    \
    "  -m, --make=TYPE    create a default makefile of TYPE; TYPE can be\n"    \
    "                     'c-project', 'cpp-project' or 'c-shared'.\n\n"       \
                                                                               \
    "Examples:\n"                                                              \
    "  new hello          create a file 'hello'.\n"                            \
    "  new hello.c        create a default C template.\n"                      \
    "  new -e hello       create a file 'hello' and open for editing in vim\n" \
    "  new -e hello.c     create a default C template file and open for.\n"    \
    "                     editing in vim.\n\n"                                 \
    "Author:\n"                                                                \
    "  Artyom Danilov\n\n"
}

# Returns 0 if $1 makefile type is in $MAKEFILE_TYPES
function makefile_supported()
{
    local type=$1

    for make_type in "${MAKEFILE_TYPES[@]}"; do
        if [[ "$make_type" == "$type" ]]; then
            return 0
        fi
    done
    return 1
}

# Copy $1 template from templates directory into $2 file.
function copy_template()
{
    local template="$TEMPLATES_DIR/$1"
    local filename=$2

    # if filename doesn't exist in pwd
    if [[ ! -f "$(pwd)/$filename" ]]; then
        # if template doesn't exist
        if [[ ! -f "$template" ]]; then
            echo "$SCRIPT_NAME: template not found '$template'" >&2
        else
            cp "$template" "$filename"
        fi
    else
        if [[ ${FLAGS[force]} -eq 1 ]]; then
            cp "$template" "$filename"
        else
            echo "$SCRIPT_NAME: file '$filename' already exists"
            read -rep 'Rewrite ? [y/n]: ' ans
            [[ "$ans" =~ ^[yY]$ ]] && cp "$template" "$filename"
        fi
    fi
}
