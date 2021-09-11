#!/bin/bash
ssh-keygen -t rsa -b 4096 -C "auto-generated-key" -q -N "" -f $HOME/.ssh/id_rsa
chmod 700 $HOME/.ssh
chmod 644 $HOME/.ssh/id_rsa.pub
chmod 600 $HOME/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa

