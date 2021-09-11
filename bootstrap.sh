#!/bin/bash

# Initial script to run to setup base environment before other scripts are ran

# *** this script must be run as root *** #
# this is also meant to setup the root user
# as similar as it can be to the user

if [ $(id -u) -ne 0 ]; then
  echo "$0 must be run as root"
  exit 1
fi

apt update -y
apt install -y software-properties-common
add-apt-repository universe
apt update -y

for package in $(cat packages); do
  DEBIAN_FRONTEND=noninteractive apt install -y $package
done

snap install iputils

apt update -y
apt upgrade -y
apt autoremove -y

tar zxvf neovim.tar.gz
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local/nvim -C neovim-0.5.0
make install -C neovim-0.5.0
echo 'export PATH="/usr/local/nvim/bin:$PATH"' >> .bashrc

wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz
echo 'export PATH="/usr/local/go/bin:$PATH"' >> .bashrc

wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/16.0.2%2B7/d4a915d82b4c4fbb9bde534da945d746/jdk-16.0.2_linux-x64_bin.tar.gz
tar zxvf jdk-16.0.2_linux-x64_bin.tar.gz -C /opt
echo 'export PATH="/opt/jdk-16.0.2/bin:$PATH"' >> .bashrc

# *** setup /etc/skel *** #
cp .bash_aliases /etc/skel
cp .bashrc /etc/skel
cp .dircolors /etc/skel
cp .profile /etc/skel
cp .tmux.conf /etc/skel
# ***                 *** #

# copy hidden skel files into current home dirs
for i in $(ls /home); do
  cp -r /etc/skel/* /home/$i
  cp -r /etc/skel/.[^.]* /home/$i
  mkdir -p /home/$i/.config/nvim
  cp init.vim /home/$i/.config/nvim
  chown -R $i:$i /home/$i

  cp -r /etc/skel/* $HOME
  cp -r /etc/skel/.[^.]* $HOME
done
mkdir -p $HOME/.config/nvim
cp init.vim $HOME/.config/nvim

##############################################################
##############################################################
##############################################################
# anything past here needs to be done for the regular user too
jurl https://pyenv.run | bash
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
nvm install --lts
nvm install v14.17.5

curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

npm install -g tldr

