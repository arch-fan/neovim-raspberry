# neovim-raspberry

Repo for installing neovim building it from source with Docker.

## Description
This repository provides a script for installing Neovim on a Raspberry Pi (64-bit). It uses Docker to build and install Neovim, ensuring compatibility with the Raspberry Pi architecture.

## Prerequisites
- Raspberry Pi with a 64-bit OS.
- Docker installed on the Raspberry Pi.

## Installation

To install the latest version of Neovim, simply run the following command:

```sh
chmod +x ./install.sh && ./install.sh
```

If you want to install a specific version of Neovim, pass the version number as an argument:

```sh
./install.sh v0.9.0
```

> [!NOTE]
>The script defaults to the latest version of Neovim if no version argument is provided. If an invalid version is specified, the script will fail with an error message.