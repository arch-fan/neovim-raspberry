FROM arm64v8/debian:stable

ARG NEOVIM_VERSION=latest

RUN apt-get update && apt-get install -y --no-install-recommends \
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
