#!/bin/bash
tar zxvf neovim.tar.gz
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local/nvim -C neovim-0.5.0
make install -C neovim-0.5.0
echo 'export PATH="/usr/local/nvim/bin:$PATH"' >> .bashrc

