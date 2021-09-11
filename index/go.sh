#!/bin/bash
wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz
echo 'export PATH="/usr/local/go/bin:$PATH"' >> .bashrc

