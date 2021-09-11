#!/bin/bash

# Initializes environment so that Python can take over

if [ $(id -u) -ne 0 ]; then
	echo "$0 is unable to install packages. Try running as root?"
	exit 1
fi

index/update.sh
index/adduniverse.sh
index/packageinstall.sh software-properties-common
index/update.sh
index/packageinstall.sh python3
index/upgrade.sh
index/autoremove.sh

echo 'Now run `python3 setup.py`'
