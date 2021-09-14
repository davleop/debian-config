#!/bin/bash
wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/16.0.2%2B7/d4a915d82b4c4fbb9bde534da945d746/jdk-16.0.2_linux-x64_bin.tar.gz
tar zxvf jdk-16.0.2_linux-x64_bin.tar.gz -C /opt
echo 'export PATH="/opt/jdk-16.0.2/bin:$PATH"' >> $1/dotfiles/.bashrc

