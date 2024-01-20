# neovim-raspberry
Steps for installing neovim newer versions on Raspberry Pi (64-bit)

Just run the install script.

```sh
chmod +x ./install.sh && ./install.sh

```

## Manual installation & explanation

```Dockerfile
FROM arm64v8/debian:latest

RUN apt-get update && apt-get install -y \
    git cmake ninja-build libtool libtool-bin autoconf automake pkg-config unzip gettext \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch v0.9.0 --depth 1 https://github.com/neovim/neovim

WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN make install

RUN apt-get purge -y git cmake ninja-build libtool libtool-bin autoconf automake pkg-config unzip gettext
RUN apt-get autoremove -y

CMD ["nvim"]
```

Execute the command

```sh
docker build -t neovim-build .
```

After the build

```sh
docker run -d --name neovim-build neovim-build 
```

Now, copy the `docker cp neovim-build:/usr/local/bin/nvim .` wherever you want
You also need the runtime, located at `docker cp neovim-build:/usr/local/share/nvim/runtime/ .`

My recomendation is to move the binary and the runtime to the same place where they were located. Then you just run `nvim`.

For choosing an specific version, change it at the dockerfile statement `RUN git clone --branch v0.9.0 https://github.com/neovim/neovim`
