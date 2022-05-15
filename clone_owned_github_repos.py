#!/usr/bin/env python3

# File:     clone_owned_github_repos.py
# Created:  10.05.22
# Author:   Artyom Danilov (@defytheflow)

import os

import requests
from requests.auth import HTTPBasicAuth


def main() -> None:
    repos = get_owned_repos()
    for i, repo in enumerate(repos):
        command = f'git clone {repo["ssh_url"]}'
        print(f'{i + 1}. Executing: "{command}"')
        os.system(command)
        print()


def get_owned_repos() -> list[dict]:
    url = 'https://api.github.com/user/repos?per_page=100&affiliation=owner'
    auth = HTTPBasicAuth('username', get_required_env_var('GITHUB_ACCESS_TOKEN'))
    return requests.get(url, auth=auth).json()


def get_required_env_var(name: str) -> str:
    value = os.getenv(name)
    if value is None:
        raise ValueError(f'"{name}" env variable must be set')
    return value


if __name__ == '__main__':
    main()
