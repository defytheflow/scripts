#!/bin/bash

# Absolute imports
. $(dirname $(realpath $0))/settings.sh
. $(dirname $(realpath $0))/helpers.sh

# Based on set FLAGS collect files to TRASH array.
function collect_trash()
{
    local dir=$1

    if [[ ${FLAGS[elf]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir '' 'ELF'
        files_to_trash $dir '' 'script'

    elif [[ ${FLAGS[exe]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir 'exe' 'script'

    elif [[ ${FLAGS[exe]} -eq 1 && ${FLAGS[elf]} -eq 1 ]]; then
        files_to_trash $dir 'exe' 'ELF'

    elif [[ ${FLAGS[no-exe]} -eq 1 && ${FLAGS[elf]} -eq 1 ]]; then
        files_to_trash $dir 'no-exe' 'ELF'

    elif [[ ${FLAGS[no-exe]} -eq 1 && ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir 'no-exe' 'script'

    elif [[ ${FLAGS[script]} -eq 1 ]]; then
        files_to_trash $dir '' 'script'

    elif [[ ${FLAGS[bin]} -eq 1 ]]; then
        files_to_trash $dir '' 'ELF'

    elif [[ ${FLAGS[exe]} -eq 1 ]]; then
        files_to_trash $dir 'exe' ''

    elif [[ ${FLAGS[no-exe]} -eq 1 ]]; then
        files_to_trash $dir 'no-exe' ''
    fi
}

# Fill TRASH array with files from $1 'dir' based on their $2 'mode' and $3 'type'.
function files_to_trash()
{
    local dir=$1
    local mode=$2  # 'exe' - executable, 'no-exe' - not executable
    local type=$3  # ELF, script

    for file in $(ls $dir); do
        local full_file="$dir/$file"

        if [[ $mode == 'exe' && -n $type ]]; then
            [[ -x $full_file && $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")

        elif [[ $mode == 'no-exe' && -n $type ]]; then
            [[ ! -x $full_file && $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")

        elif [[ -n $type ]]; then
            [[ $(file $full_file) =~ "$type" ]] && TRASH+=("$full_file")

        elif [[ $mode == 'exe' ]]; then
            [[ -x "$full_file" ]] && TRASH+=("$full_file")

        elif [[ $mode == 'no-exe' ]]; then
            [[ ! -x "$full_file" ]] && TRASH+=("$full_file")
        fi
    done
}

# '--no-exe' and '--exe' are conflicting options
if [[ ${FLAGS[exe]} -eq 1 && ${FLAGS[no-exe]} -eq 1 ]]; then
    echo "$SCRIPT_NAME: conflicting options '--exe' and '--no-exe'" >&2
    echo $HELP >&2
    exit 1
fi

# If no <dir>s were given:
if [[ $# -eq 0 ]]; then
    collect_trash '.'
else
    # For each <dir>:
    for dir in "$@"; do
            # If <dir exists:
            if [[ -d "$dir" ]]; then
                collect_trash "$dir"
            fi
    done
fi

# If collected trash:
if [[ ${#TRASH[@]} -gt 0 ]]; then
    remove_trash
fi

exit 0
