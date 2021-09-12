#!/bin/bash

rm -rf /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux
pushd /tmp/tmux
git checkout 3.0a
sh autogen.sh
./configure && make
make install
popd
