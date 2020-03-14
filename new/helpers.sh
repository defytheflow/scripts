#!/bin/bash

# Returns 0 if $1 is in $MAKEFILES
makefile_supported()
{
    for lang in "${SUPPORTED_MAKEFILES[@]}"; do
        [[ "$lang" == "$1" ]] && return 0
    done
    return 1
}

# Copies $1 template from $TEMPLATES_DIR_NAME directory into $2 file
copy_template()
{
    local template="$TEMPLATES_DIR_NAME/$1"
    local file=$2

    # if file doesn't exist in pwd
    if [[ ! -f $(pwd)/$file ]]; then
        # if template doesnt exist
        if [[ ! -f $template ]]; then
            echo "Error: template not found '$template'" >&2
        else
            cp "$template" "$file"
        fi
    else

        if [[ ${FLAGS[force]} -eq 1 ]]; then
            cp "$template" "$file"
        else
            echo "Warning: file already exists '$file'"
            read -rep "Rewrite ? [y/n]: " ans
            [[ "$ans" =~ ^[yY]$ ]] && cp "$template" "$file"
        fi

    fi
}
