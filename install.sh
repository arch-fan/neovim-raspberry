#!/bin/bash

docker build -t neovim-build .
docker run -d --name neovim-build neovim-build
docker cp neovim-build:/usr/local/bin/nvim /usr/local/bin/nvim
docker cp neovim-build:/usr/local/share/nvim/runtime/ /usr/local/share/nvim/runtime/
docker rm -f neovim-build
docker rmi neovim-build
