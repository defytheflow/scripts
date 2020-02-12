"""Commenting tool.

Usage:
  comment [options] [--] <file>...

Arguments:
  file                          name of the file

Options:
  -h, --help                    displays a usage message.
  -l <lang>, --lang <lang>      specific language settings.

Examples:
  comment hello.c

Author:
  Artyom Danilov
"""

import os
import re
import sys
import getopt

from utils import printerr


FLAGS = {"lang": "c"}  # default
SUPPORTED_LANGUAGES = ("c", "cpp")

HELP_MESSAGE = f"Try 'comment -h | --help' for more information."


def parse_args(argv: list):
    """
        Parses command line arguments.

        Returns:

    """
    require_arguments = ["l", "lang"] # options that require arguments
    try:

        return getopt.getopt(argv, "hl:", ["help", "lang="])

    except getopt.GetoptError as err:

        if err.opt in require_arguments:
            printerr(f"Error: option '{err.opt}' requires an argument")
        else:
            printerr(f"Error: unknown option '{err.opt}'")

        printerr(HELP_MESSAGE)
        sys.exit(1)


def set_flags(options: list):
    """
        Sets up global 'FLAGS' dictionary based on 'options' list.
    """
    for opt, arg in options:

        if opt in ("-h", "--help"):
            print(__doc__)
            sys.exit(0)

        if opt in ("-l", "--lang"):

            if arg.lower() in SUPPORTED_LANGUAGES:
                FLAGS["lang"] = arg
            else:
                printerr(f"Error: '{arg}' language is not supported",
                         f"Supported languages: {', '.join(SUPPORTED_LANGUAGES)}",
                         HELP_MESSAGE, sep="\n")
                sys.exit(1)


def main():

    opts, args = parse_args(sys.argv[1:])
    set_flags(opts)

    for file_ in args:

        if not os.path.exists(file_):
            printerr(f"Error: '{file_}' file not found", HELP_MESSAGE, sep="\n")
            continue

        if not os.path.isfile(file_):
            printerr(f"Error: '{file_}' is not a file\n", HELP_MESSAGE, sep="\n")
            continue

        name, extension = os.path.splitext(file_)

        # Check that file extension matches 'lang' flag
        if extension[1:] != FLAGS["lang"]:
            printerr(f"Error: '{name}' must end with '.{FLAGS['lang']}'",
                     HELP_MESSAGE, sep="\n")
            continue

        # The JOB
        # Check the top comment
        # Check that every function definition except for main has a comment.


if __name__ == "__main__":
    main()
