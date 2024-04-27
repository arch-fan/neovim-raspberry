#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

NEOVIM_VERSION=${1:-latest}

docker build --build-arg NEOVIM_VERSION=${NEOVIM_VERSION} -t neovim-build .

docker run -d --name neovim-build neovim-build
docker cp neovim-build:/neovim/build/nvim-linux64.deb ./nvim-linux64.deb
sudo apt install -y ./nvim-linux64.deb
rm ./nvim-linux64.deb
docker rm -f neovim-build
docker rmi neovim-build
