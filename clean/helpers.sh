#!/bin/bash

# Display usage message.
function usage()
{
    printf "%b"                                                                \
    "Remove certain types of files from directories.\n\n"                      \
                                                                               \
    "Usage:\n"                                                                 \
    "  clean [options] <dirname>...\n\n"                                       \
                                                                               \
    "Arguments:\n"                                                             \
    "  dirname         name of the directory.\n\n"                             \
                                                                               \
    "Options:\n"                                                               \
    "  -e, --elf       remove ELF files (default).\n"                          \
    "  -f, --force     do not prompt when remove.\n"                           \
    "  --help          display this message and exit.\n"                       \
    "  -n, --no-exe    remove non-executable files.\n"                         \
    "  -s, --script    remove scripts.\n"                                      \
    "  -x, --exe       remove executable files.\n\n"                           \
                                                                               \
    "Examples:\n"                                                              \
    "  clean           remove all ELFs from cwd\n"                             \
    "  clean -e        remove all ELFS from cwd\n"                             \
    "  clean -s        remove all scripts from cwd\n"                          \
    "  clean -x        remove all executable files from cwd\n"                 \
    "  clean -n        remove all non-executable files from cwd\n"             \
    "  clean -xs       remove all executable scripts from cwd\n"               \
    "  clean -xe       remove all executable ELFS from cwd\n"                  \
    "  clean -es       remove all ELFS and scripts from cwd\n"                 \
    "  clean -ne       remove non-executable ELFS from cwd\n"                  \
    "  clean -ns       remove non-executable scripts from cwd\n"
}

# Display files in TRASH array and prompt to remove them.
function remove_trash()
{
    if [[ ${FLAGS[force]} -eq 1 ]]; then
        remove_files "${TRASH[@]}"
    else
        printf "'%s'\n" "${TRASH[@]}"

        # Prompt to remove.
        if [[ ${#TRASH[@]} -eq 1 ]]; then
            echo -n "$SCRIPT_NAME: remove this file? [y/n]: "
        else
            echo -n "$SCRIPT_NAME: remove these files? [y/n]: "
        fi

        read -re ans
        if [[ "$ans" =~ ^[yY]$ ]]; then
            remove_files "${TRASH[@]}"
        fi
    fi

}

function remove_files()
{
    for file in "$@"; do
        rm "$file"
    done
}
