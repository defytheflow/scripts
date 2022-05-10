#!/usr/bin/env python3

import os

import requests
from requests.auth import HTTPBasicAuth


def main() -> None:
    urls = get_owned_repos_urls()

    for i, url in enumerate(urls):
        command = f'git clone {url}'
        print(f'{i + 1}. Executing: "{command}"')
        os.system(command)
        print()


def get_owned_repos_urls() -> list[str]:
    access_token = get_required_env_var("GITHUB_ACCESS_TOKEN")
    per_page = 100
    response = requests.get(
        f'https://api.github.com/user/repos?per_page={per_page}&affiliation=owner',
        auth=HTTPBasicAuth('username', access_token),
    )
    repos = response.json()
    return [repo['ssh_url'] for repo in repos]


def get_required_env_var(name: str) -> str:
    value = os.getenv(name)

    if value is None:
        raise ValueError(f'"{name}" env variable must be set')

    return value


if __name__ == '__main__':
    main()
