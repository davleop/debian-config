#!/bin/false
# please use `python3` command to execute

import os
import json
import argparse

from sys import exit
from subprocess import run as srun

# CONSTANTS
SUDO = False

# Load shell files from index
with open('index.json') as f:
    _index = json.load(f)
ROOT = _index['root']
USER = _index['user']

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

### *** SUDO *** ###
def permissions():
    if not SUDO:
        parser.print_help()
        exit(1)

def update():
    permissions()
    return run([ROOT['update'][0]])

def upgrade():
    permissions()
    return run([ROOT['upgrade'][0]])

def autoremove():
    permissions()
    return run([ROOT['autoremove'][0]])

def adduniverse():
    permissions()
    return run([ROOT['adduniverse'][0]])

def packageinstall(package):
    permissions()
    return run([ROOT['packageinstall'][0], package])

def snapinstall(package):
    permissions()
    return run([ROOT['snapinstall'][0], package])

def install_packages(package_json_path):
    permissions()

    with open(package_json_path) as f:
        packages = json.load(f)

    for k, v in packages.items():
        if   v == 'apt':
            packageinstall(k)
        elif v == 'snap':
            snapinstall(k)
        else:
            raise Exception('Supported package managers are (apt/snap)')

def neovim():
    permissions()
    return run([ROOT['neovim'][0]])

def go():
    permissions()
    return run([ROOT['go'][0]])

def java():
    permissions()
    return run([ROOT['java'][0]])

def addskel():
    permissions()
    return run([ROOT['addskel'][0]])

def updateoldusers(overwrite=False):
    permissions()

    if overwrite:
        return run([ROOT['updateoldusers'][0], "overwrite"])
    else:
        return run([ROOT['updateoldusers'][0]])

def updaterootshell(overwrite=False):
    permissions()

    if overwrite:
        return run([ROOT['updaterootshell'][0], "overwrite"])
    else:
        return run([ROOT['updaterootshell'][0]])

def installtmux():
    permissions()
    return run([ROOT['installtmux'][0]])

### *** SUDO *** ###

### *** USER *** ###

def pyenv():
    return run([USER['pyenv'][0]])

def sshkey():
    return run([USER['sshkey'][0]])

def rust():
    return run([USER['rust'][0]])

def nvm():
    return run([USER['nvm'][0]])

def plugvim():
    return run([USER['plugvim'][0]])

def npm(package):
    return run([USER['npm'][0], package])

def fuck():
    return run([USER['fuck'][0]])

### *** USER *** ###

def main():
    pass

if __name__ == '__main__':
    main()
