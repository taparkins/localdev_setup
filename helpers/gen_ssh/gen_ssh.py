#!/usr/bin/python

import datetime, getpass, os, re
from subprocess import call


BASE_SSH_DIR = '/Users/aparkinson/.ssh'


def create_key(passphrase, key_path):
    call([
        'ssh-keygen',
        '-t', 'rsa',
        '-N', passphrase,
        '-f', key_path,
    ])


def update_config(key_path):
    data = None
    config_path = os.path.join(BASE_SSH_DIR, 'config')
    with open(config_path, 'r') as f:
        data = f.read()

    new_data = re.sub(
        r'^(Host \*)$',
        r'\1\n    {}'.format(key_path),
        data,
        flags=re.MULTILINE,
    )
    with open(config_path, 'w') as f:
        f.write(new_data)


def main(passphrase):
    time = datetime.datetime.utcnow()
    date_fmt = datetime.date.isoformat(time)
    key_name = 'id_rsa-{}'.format(date_fmt)
    abs_key_path = os.path.join(BASE_SSH_DIR, key_name)
    create_key(passphrase, abs_key_path)
    update_config(abs_key_path)


print('Provide ssh passphrase:')
passphrase = getpass.getpass()
main(passphrase)
