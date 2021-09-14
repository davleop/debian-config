#!/bin/bash
cp $1/dotfiles/.bash_aliases /etc/skel
cp $1/dotfiles/.bashrc /etc/skel
cp $1/dotfiles/.dircolors /etc/skel
cp $1/dotfiles/.profile /etc/skel
cp $1/dotfiles/.tmux.conf /etc/skel

