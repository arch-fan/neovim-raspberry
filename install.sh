#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

NEOVIM_VERSION=${1:-latest}

docker build --build-arg NEOVIM_VERSION=${NEOVIM_VERSION} -t neovim-build .

docker run -d --name neovim-build neovim-build
docker cp neovim-build:/usr/local/bin/nvim /usr/local/bin/nvim
docker cp neovim-build:/usr/local/share/nvim/runtime/ /usr/local/share/nvim/runtime/
docker rm -f neovim-build
docker rmi neovim-build
