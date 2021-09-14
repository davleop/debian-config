#!/usr/bin/python3
# please use `python3` command to execute

import os
import sys
import json
#import inspect
import argparse

from sys import exit
from subprocess import run as srun

if sys.version_info < (3,6):
    print('Please upgrade your Python version to 3.6.0 or higher')
    exit(1)

# CONSTANTS
SUDO  = False
PACKS = 'luggage/packages.json'

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
parser.add_argument('--do-everything', '-e', action='store_true', help='Requires root permissions. Will setup everything in my configuration for all users')
args = parser.parse_args()

def run(cmd):
    return srun(cmd, shell=True, capture_output=True)

### \/ \/ \/ SUDO \/ \/ \/ ###
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
        elif v == 'npm':
            pass
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

def runas(usr,cmd):
    permissions()
    return run([f'su - {usr} -s "{cmd}"'])

### /\ /\ /\ SUDO /\ /\ /\ ###

### \/ \/ \/ USER \/ \/ \/ ###

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

def install_all_npm(package_json_path):
    with open(package_json_path) as f:
        packages = json.load(f)

    for k, v in packages.items():
        if   v == 'apt': pass
        elif v == 'snap': pass
        elif v == 'npm':
            npm(k)
        else:
            raise Exception('Supported package managers are (apt/snap)')

def fuck():
    return run([USER['fuck'][0]])

### /\ /\ /\ USER /\ /\ /\ ###

#def get_funcs():
#    funcs = [
#        name for name,obj in inspect.getmembers(sys.modules[__name__]) if inspect.isfunction(obj)
#    ]
#    funcs.pop(funcs.index('main'))
#    funcs.pop(funcs.index('get_funcs'))
#    funcs.pop(funcs.index('run'))
#    return funcs

def list_users():
    return os.listdir('/home')

def do_everything():
    root_calls = [
        update,
        adduniverse,
        update,
        install_packages,
        update,
        upgrade,
        autoremove,
        neovim,
        go,
        java,
        addskel,
        updateoldusers,
        updaterootshell,
        installtmux
    ]

    user_calls = []
    for k,v in USER.items():
        user_calls.append(k)

    executions = []

    for func in root_calls:
        print(f'Executing {func.__name__}')
        if   func is install_packages:
            executions.append(func(PACKS))
        elif func is updateoldusers:
            executions.append(func(True))
        elif func is updaterootshell:
            executions.append(func(True))
        else:
            executions.append(func())

    for usr in list_users():
        for func in user_calls:
            print(f'Executing {func}')
            if eval(func) is npm:
                executions.append(install_all_npm(PACKS))
            else:
                executions.append(runas(usr,USER[func][0]))

    return executions

def log(cmd, rc, sout, serr):
    return f'{cmd}::RC[{rc}]\nSTDOUT:{sout}\n\nSTDERR: {serr}\n\n'

def main():
    if len(sys.argv) <= 1:
        parser.print_help()
        exit(0)
    executions = []
    if args.do_everything:
        executions = do_everything()

    success = []
    failure = []
    print(failure)
    '''
    if executions:
        for p in executions:
            if p.returncode == 0:
                success.append(log(p.args,p.returncode,p.stdout,p.stderr))
            else:
                failure.append(log(p.args,p.returncode,p.stdout,p.stderr))

    s = open('success.log','w')
    f = open('failure.log','w')
    s.write('\n'.join(success))
    f.write('\n'.join(failure))
    s.close()
    f.close()
    '''

if __name__ == '__main__':
    main()
