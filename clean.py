#!/usr/bin/python3

# Program:
#     clean
#
# Author:
#     Artyom Danilov.
#
# Date:
#     August 31st, 2019.
#
# Updated:
#     November 25th, 2019.
#     December 23d,  2019.  - Changed the prompt if only one file to be removed.
#			      Now shows "Remove this file? (y/n)"
#
# Description:
#     Removes all executable files from the directory.
#
# Goal:
#     Being able to efficiently remove executable files while practicing.
#     (Writing throw-away C/C++ programs, trying out snippers of code, etc.)
#
# Usage:
#     clean [-h] [-b | -s] [<dir_name>]
#
# Options:
#     -h, --help - Displays the help message.
#     -b, --bin  - Removes only executable binaries (C, C++).
#     -s, --script - Removes only executable scripts. (Python, Bash, etc.)
#
# Arguments:
#     [<dir_name>] - Name of the Directory from where to remove executables.
#
# Dependencies:
#     colorama
#     pydtfl


import os
import sys
import argparse

from colorama import Fore, Style

from pydtfl.error import error
from pydtfl.colors import make_yellow
from pydtfl.file_system import get_file_type


def main():
    """ The main function that runs the script. """
    argv = parse_args()

    dir_name = argv.dir_name if argv.dir_name else os.getcwd()
    bin_flag = argv.bin
    script_flag = argv.script

    if os.path.isdir(dir_name):
        entries = os.listdir(os.path.abspath(dir_name))
        files = [entry for entry in entries if os.path.isfile(entry)]
    else:
        error(f"directory '{dir_name}' doesn't exist")

    if bin_flag:
        remove(files, "b")
    elif script_flag:
        remove(files, "s")
    else:
        remove(files, "a")

    sys.exit(0)


def remove(files: list, mode: str):
    """
        Descr:
            Finds all the executables and prompts the user to delete them.
        Args:
            'files' - list of files from the given directory.
            'mode'  - what types of executable to remove.
                      "b" - binary, "s" - scripts, "a" - all.
    """
    files_to_remove = []

    if mode == "s":
        collect_scripts(files, files_to_remove)
    elif mode == "b":
        collect_binaries(files, files_to_remove)
    else:
        collect_executables(files, files_to_remove)

    if files_to_remove:
        prompt_to_remove(files_to_remove)


def prompt_to_remove(files_to_remove: list):
    """
        Descr:
            Prints all the files from the 'files_to_remove' list.
            Prompts the user whether to remove them or not.
        Args:
            'files_to_remove' - list of files that are to be removed.
    """
    for file in files_to_remove:
        print("- '" + file + "'")

    print(make_yellow("Remove"), end=" ")
    if len(files_to_remove) == 1:
        print("this file?", end=" ")
    else:
        print("all these files?", end=" ")
    print("(y/n)", end=" ")

    answer = input()
    if answer in ("y", "Y", "yes", "YES"):
        for file in files_to_remove:
            os.remove(file)


def collect_scripts(files: list, files_to_remove: list):
    """
       Descr:
           Fills the 'files_to_remove' list with files that
           are executable scripts.
       Args:
          'files' - list of files in the given directory.
          'files_to_remove' - list of files to be removed.
    """
    for file in files:
        if os.access(file, os.X_OK) and "script" in get_file_type(file):
            files_to_remove.append(file)


def collect_binaries(files: list, files_to_remove: list):
    """
       Descr:
           Fills the 'files_to_remove' list with files that
           are executable binaries.
       Args:
          'files' - list of files in the given directory.
          'files_to_remove' - list of files to be removed.
    """
    for file in files:
        if os.access(file, os.X_OK) and "text" not in get_file_type(file):
            files_to_remove.append(file)


def collect_executables(files: list, files_to_remove: list):
    """
       Descr:
           Fills the 'files_to_remove' list with files that
           are executable.
       Args:
          'files' - list of files in the given directory.
          'files_to_remove' - list of files to be removed.
    """
    for file in files:
        if os.access(file, os.X_OK):
            files_to_remove.append(file)


def parse_args() -> argparse.Namespace:
    """ Parses Command Line Arguments. """
    parser = argparse.ArgumentParser(description="Removes all "
                                     "executable files from the directory")
    parser.add_argument("dir_name", nargs="?", help="Name of the Directory"
                        " from where to remove executables")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-b", "--bin", action="store_true",
                       help="Removes only executable binaries (C, C++)")
    group.add_argument("-s", "--script", action="store_true",
                       help="Removes only executable scripts. (Python, "
                       "Bash, etc.)")
    return parser.parse_args()


if __name__ == "__main__":
    main()
