#!/bin/bash

usage()
{
    printf "%b"                                                                \
    "Removes certain types of files from directory.\n\n"                       \
                                                                               \
    "Usage:\n"                                                                 \
    "  clean [options] <dir>...\n\n"                                           \
                                                                               \
    "Arguments:\n"                                                             \
    "  dir           name of the directory\n\n"                                \
                                                                               \
    "Options:\n"                                                               \
    "  -b            remove ELF files           (default)\n"                   \
    "  -f            remove without prompt.\n"                                 \
    "  -h            display this message.\n"                                  \
    "  -n            remove non-executable files.\n"                           \
    "  -s            remove script files.\n"                                   \
    "  -x            remove executable files.\n\n"                             \
                                                                               \
    "Examples:\n"                                                              \
    "  clean         remove all ELFs from cwd\n"                               \
    "  clean -b      remove all ELFS from cwd\n"                               \
    "  clean -s      remove all scripts from cwd\n"                            \
    "  clean -x      remove all executable files from cwd\n"                   \
    "  clean -n      remove all non-executable files from cwd\n"               \
    "  clean -xs     remove all executable scripts from cwd\n"                 \
    "  clean -xb     remove all executable ELFS from cwd\n"                    \
    "  clean -bs     remove all ELFS and scripts from cwd\n"                   \
    "  clean -nb     remove non-executable ELFS from cwd\n"                    \
    "  clean -ns     remove non-executable scripts from cwd\n\n"               \
                                                                               \
    "Author:\n"                                                                \
    "  Artyom Danilov\n\n"
}

# Absolute import
. $(dirname $(realpath $0))/settings.sh

# Based on set FLAGS collect files to TRASH array.
collect_trash()
{
    local dir=$1
    if [[ ${FLAGS[bin]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir "script" ""
        files_to_trash $dir "ELF" ""
    elif [[ ${FLAGS[exec]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir "script" "x"
    elif [[ ${FLAGS[exec]} -eq 1 && ${FLAGS[bin]} -eq 1 ]]; then
        files_to_trash $dir "ELF" "x"
    elif [[ ${FLAGS[no_exec]} -eq 1 && ${FLAGS[bin]} -eq 1 ]]; then
        files_to_trash $dir "ELF" "n"
    elif [[ ${FLAGS[no_exec]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir "script" "n"
    elif [[ ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir "script"
    elif [[ ${FLAGS[bin]} -eq 1 ]]; then
        files_to_trash $dir "ELF"
    elif [[ ${FLAGS[exec]} -eq 1 ]]; then
        files_to_trash $dir "" "x"
    elif [[ ${FLAGS[no_exec]} -eq 1 ]]; then
        files_to_trash $dir "" "n"
    fi
}

# Fill TRASH array with files from dir based on their type and mode.
files_to_trash()
{
    local dir=$1
    local type=$2
    local mode=$3  # x - executable, n - not executable

    for file in $(ls $dir); do
        local full_file="$dir/$file"
        if [[ $mode == "x" && -n $type ]]; then
            [[ -x $full_file && $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")
        elif [[ $mode == "n" && -n $type ]]; then
            [[ ! -x $full_file && $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")
        elif [[ -n $type ]]; then
            [[ $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")
        elif [[ $mode == "x" ]]; then
            [[ -x "$full_file" ]] && TRASH+=("$full_file")
        elif [[ $mode == "n" ]]; then
            [[ ! -x "$full_file" ]] && TRASH+=("$full_file")
        fi

    done
}

remove_trash()
{
    if [[ ${FLAGS[force]} -eq 1 ]]; then
        remove_files "${TRASH[@]}"
    else
        for file in "${TRASH[@]}"; do
            echo "'$file'"
        done

        if [[ ${#TRASH[@]} -eq 1 ]]; then
            echo -n "Remove this file? [y/n]: "
        else
            echo -n "Remove these files? [y/n]: "
        fi

        read -re ans
        [[ "$ans" =~ ^[yY]$ ]] && remove_files "${TRASH[@]}"
    fi

}

remove_files()
{
    for file in "$@"; do
        rm "$file"
    done
}

# -n and -x are conflicting options
if [[ ${FLAGS[exec]} -eq 1 && ${FLAGS[no_exec]} -eq 1 ]]; then
    echo "Error: conflicting options '-x' and '-n'" >&2
    echo $HELP_MSG >&2
    exit 1
fi

# If no <dir> arguments were given
if [[ $# -eq 0 ]]; then
    collect_trash .
else
    for dir in "$@"; do
            [[ -d "$dir" ]] && collect_trash "$dir"
    done
fi

# If collected any trash ->
[[ ${#TRASH[@]} -gt 0 ]] && remove_trash

exit 0
