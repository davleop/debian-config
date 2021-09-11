#!/bin/bash
pip install thefuck --user
echo 'eval $(thefuck --alias)' >> $HOME/.bashrc
