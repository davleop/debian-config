#!/bin/bash

curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc

ssh-keygen -t rsa -b 4096 -C "auto-generated-key" -q -N "" -f $HOME/.ssh/id_rsa
chmod 700 $HOME/.ssh
chmod 644 $HOME/.ssh/id_rsa.pub
chmod 600 $HOME/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa

curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# install for regular user too
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lst
nvm install v14.17.5

curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

npm install -g tldr

pip install install thefuck --user
echo 'eval $(thefuck --alias)' >> $HOME/.bashrc

