#!/usr/bin/env python3

# File:     rest_your_eyes_scheduler.py
# Created:  15.05.22
# Author:   Artyom Danilov (@defytheflow)

import logging
import os
import sched
import subprocess
import time

scheduler = sched.scheduler(time.time, time.sleep)
notifications = 1

SHORT_PERIOD_SECONDS = 60 * 60
LONG_PERIOD_SECONDS = 60 * 60 * 3


def main() -> None:
    '''
    Display a notification every hour and every three hours that reminds you
    to rest your eyes.
    '''
    logging.basicConfig(
        level=logging.INFO,
        format='%(levelname)s: [%(asctime)s] - %(message)s',
    )
    set_terminal_title('Rest your eyes scheduler 👀 ')
    logging.info('rest_your_eyes_scheduler started')
    scheduler.enter(SHORT_PERIOD_SECONDS, 1, display_short_period_notification)
    scheduler.enter(LONG_PERIOD_SECONDS, 1, display_long_period_notification)
    scheduler.run()


def display_short_period_notification() -> None:
    global notifications

    if notifications % 3 != 0:
        display_notification(
            title='Rest your eyes 👀 ',
            body='Close your eyes or look outside the window for a minute.',
        )
        logging.info('display_short_period_notification()')

    notifications += 1
    scheduler.enter(SHORT_PERIOD_SECONDS, 1, display_short_period_notification)


def display_long_period_notification() -> None:
    display_alert(
        title='Rest your eyes 👀 ',
        body='Take a 15 minute break from looking at any screens.',
    )
    logging.info('display_long_period_notification()')
    scheduler.enter(LONG_PERIOD_SECONDS, 1, display_long_period_notification)


def set_terminal_title(title: str) -> None:
    ''' Set the title of the current terminal tab. '''
    command = f'printf "\033]0;%s\007" "{title}"'
    os.system(command)


def display_alert(title: str, body: str) -> None:
    ''' Display a confirmation alert in the center on Mac OS. '''
    subprocess.run(
        ['osascript', '-e', f'display alert "{title}" message "{body}"'],
        capture_output=True,
    )


def display_notification(title: str, body: str) -> None:
    ''' Display a notification in the top right corner on Mac OS. '''
    command = f'osascript -e \'display notification "{body}" with title "{title}"\''
    os.system(command)


if __name__ == '__main__':
    main()
