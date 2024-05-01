#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

NEOVIM_VERSION=${1:-latest}

DOCKERFILE_CONTENT=$(cat <<EOF
FROM arm64v8/debian:latest

ARG NEOVIM_VERSION=latest

RUN apt-get update && apt-get install -y \
    git cmake ninja-build libtool libtool-bin autoconf automake pkg-config unzip gettext \
    && rm -rf /var/lib/apt/lists/*

RUN if [ "$NEOVIM_VERSION" = "latest" ]; then \
    git clone --depth 1 https://github.com/neovim/neovim; \
    else \
    git clone --branch ${NEOVIM_VERSION} --depth 1 https://github.com/neovim/neovim; \
    fi

WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd build && cpack -G DEB

CMD ["echo", "nothing to look here"]
EOF
)

echo "$DOCKERFILE_CONTENT" | docker build --build-arg NEOVIM_VERSION=${NEOVIM_VERSION} -t neovim-build -

docker run -d --name neovim-build neovim-build
docker cp neovim-build:/neovim/build/nvim-linux64.deb ./nvim-linux64.deb
sudo apt install -y ./nvim-linux64.deb
rm ./nvim-linux64.deb
docker rm -f neovim-build
docker rmi neovim-build
