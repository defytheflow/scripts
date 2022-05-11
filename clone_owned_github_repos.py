#!/usr/bin/env python3

import os

import requests
from requests.auth import HTTPBasicAuth


def main() -> None:
    repos = get_owned_repos()
    urls = [repo['ssh_url'] for repo in repos]

    for i, url in enumerate(urls):
        command = f'git clone {url}'
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
