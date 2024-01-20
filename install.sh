#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

# Tomar la versión de neovim como el primer argumento del script
NEOVIM_VERSION=${1:-latest}

# Construir la imagen con el argumento proporcionado o 'latest' si no se proporciona ninguno
docker build --build-arg NEOVIM_VERSION=${NEOVIM_VERSION} -t neovim-build .

# El resto del script sigue igual
docker run -d --name neovim-build neovim-build
docker cp neovim-build:/usr/local/bin/nvim /usr/local/bin/nvim
docker cp neovim-build:/usr/local/share/nvim/runtime/ /usr/local/share/nvim/runtime/
docker rm -f neovim-build
docker rmi neovim-build
