FROM arm64v8/debian:latest

RUN apt-get update && apt-get install -y \
    git cmake ninja-build libtool libtool-bin autoconf automake pkg-config unzip gettext \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch v0.9.0 https://github.com/neovim/neovim

WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN make install

RUN apt-get purge -y git cmake ninja-build libtool libtool-bin autoconf automake pkg-config unzip gettext
RUN apt-get autoremove -y

CMD ["nvim"]
