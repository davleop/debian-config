#!/bin/bash

# Initial script to run to setup base environment before other scripts are ran

# *** this script must be run as root *** #

if [ $(id -u) -ne 0 ]; then
  echo "$0 must be run as root"
  exit 1
fi

cd $HOME

DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y software-properties-common
add-apt-repository universe
apt update -y

for package in $(cat packages); do
  apt install -y $package
done

apt update -y
apt upgrade -y
apt autoremove -y

# install for regular user too
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install --lst
nvm install v14.17.5
#

tar zxvf neovim.tar.gz
make CMAKE_BUILD_TYPE=Release -C neovim-0.5.0
make install

wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile

wget https://download.oracle.com/otn-pub/java/jdk/16.0.2%2B7/d4a915d82b4c4fbb9bde534da945d746/jdk-16.0.2_linux-x64_bin.deb
dpkg -i jdk-16.0.2_linux-x64_bin.deb


# anything past here needs to be done for the regular user too
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

