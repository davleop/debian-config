#!/bin/false
# please use `python3` command to execute

import os
import json
import argparse

from sys import exit
from subprocess import PIPE
from subprocess import run as srun

# CONSTANTS
SUDO    = False
APT     = 'index/packageinstall.sh'
SNAP    = 'index/snapinstall.sh'
UPDATE  = 'index/update.sh'
UPGRADE = 'index/upgrade.sh'
AUTORM  = 'index/autoremove.sh'

# check if user has privileges
if os.getuid() == 0:
    SUDO = True

### parser block ###
parser = argparse.ArgumentParser(description='Setup script for installing a base Debian config')
# parser.add_argument('--option', '-o', help='')
parser.add_argument('--do-everything', '-e', action='store_true', help='Requires root permissions. Will setup everything')
args = parser.parse_args()

def run(cmd):
    return srun(cmd, shell=True, capture_output=True)

def install_packages(package_json_path):
    if not SUDO:
        parser.print_help()
        exit(1)

    with open(package_json_path) as f:
        packages = json.load(f)

    for k, v in packages.items():
        if v == 'apt':
            run([APT, k])
        elif v == 'snap':
            run([SNAP, k])
        else:
            raise Exception('Invalid or unknown package manager')

def neovim():
    pass

def go():
    pass

def java():
    pass

def rust():
    pass

def main():
    pass

if __name__ == '__main__':
    main()
