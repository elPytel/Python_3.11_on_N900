# Python 3.11 Compilation Guide for N900

> [!warning]
> This app was not yet tested on the N900 device. Use at your own risk.

- [Python 3.11 Compilation Guide for N900](#python-311-compilation-guide-for-n900)
  - [Compilation Guide](#compilation-guide)
    - [Usage](#usage)
    - [Compilation](#compilation)
    - [Validate the output binary](#validate-the-output-binary)
  - [Limitations](#limitations)
  - [Changing Python Version](#changing-python-version)
  - [OpenSSL](#openssl)
  - [Resources](#resources)

## Compilation Guide

> [!note]
> This guide assumes you are using a Debian-based system (like **Ubuntu 24.04**) on an x86_64 architecture.

### Usage
Run the script `compile_python.sh` on your x86_64 device to cross-compile Python 3.11 for the N900 device. 
This script automates the process of downloading, configuring, and compiling Python 3.11.

The script installs dependencies listed in the `dependencies.txt` file, such as:
```txt
arm-linux-gnueabihf-gcc
gcc-arm-linux-gnueabihf 
g++-arm-linux-gnueabihf
crossbuild-essential-armhf
build-essential
...
```

### Compilation

The script `compile_python.sh` will configure the make file for cross-compilation, and compile it for the ARM architecture. Used settings are:
```bash
CC=arm-linux-gnueabihf-gcc \
./configure \
  --build="$(./config.guess)" \
  --host=arm-linux-gnueabihf \
  --prefix="$INSTALL_DIR" \
  --enable-optimizations \
  --disable-ipv6 \
  --enable-shared \
  --without-ensurepip \
  --with-build-python=/usr/bin/python3.11 \
  ac_cv_file__dev_ptmx=no \
  ac_cv_file__dev_ptc=no
```

### Validate the output binary
After running the script, Python 3.11 will be installed in the `python-arm-install` directory. 

> [!note] 
> Check if the installation was successful by running:

```bash
file python-arm-install/bin/python3.11
```

It should output something like: `ELF 32-bit ARM`

## Limitations

This guide does not support IPv6.
```
configure: error: You must get working getaddrinfo() function or pass the "--disable-ipv6" option to configure.
```


Could not build the ssl module!
Python requires a OpenSSL 1.1.1 or newer

## Changing Python Version

For compiling Python 3.11 you need compatible versions of Python and its dependencies already installed on your system. If you change the Python version, you may need to update the dependencies accordingly.

> [!warning]
> ```
>checking for --with-build-python... configure: error: "/usr/bin/python3" has incompatible version 3.12 (expected: 3.11)
> ```

## OpenSSL

> [!warning] TODO
> This script was not yet done.

## Resources
- [Build python 3.11 on raspberry pi from source](https://cloasdata.de/?p=352)