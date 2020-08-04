#!/usr/bin/env python
import os
import re
import sys
from typing import List

__script__ = sys.argv[0]

INCLUDE_PATTERN = r'^\s*#include\s+[<"][\w\W]+\.h[>"]\s*$'


def main(argv):
    if len(argv) == 0:
        error('missing <fname> argument.')

    for fname in argv:

        if not os.path.isfile(fname):
            error(f'file {fname} does not exist.', fatal=False)
            continue

        with open(fname, 'r') as file:
            flines = file.readlines()

        includes = [
            line.replace('#include', '').strip() for line in flines
            if re.match(INCLUDE_PATTERN, line)
        ]

        if len(includes) <= 1:
            print(''.join(flines), end='')

        local_includes = std_includes = []

        for include in includes:
            if include[0] == '"':
                local_includes.append(include)
            else:
                std_includes.append(include)

        for include in local_includes:
            include = include[1:-3]
            prefix, _, _ = fname.rpartition('.')
            if include[1:-3] == prefix:

            print(include)


def error(*args, fatal=False):
    print(f'{__script__}:', *args, file=sys.stderr)
    if fatal: sys.exit(1)


if __name__ == '__main__':
    main(sys.argv[1:])
