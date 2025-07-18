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
- [Packaging Python 3.11 for N900](#packaging-python-311-for-n900)
  - [Build guide](#build-guide)
    - [Run the packaging script to create folder structure](#run-the-packaging-script-to-create-folder-structure)
    - [Edit the control file](#edit-the-control-file)
    - [Move the python binaries](#move-the-python-binaries)
    - [Build the Debian package](#build-the-debian-package)
    - [Copy the package to N900 over SSH](#copy-the-package-to-n900-over-ssh)

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

# Packaging Python 3.11 for N900

Run helper script `package_python.sh` to create a Debian package for Python 3.11. 

## Build guide
### Run the packaging script to create folder structure
Run the script `package_python.sh` to create the necessary directory structure for packaging Python 3.11:
```bash
./package_python.sh
```

### Edit the control file
You have to manually edit the `DEBIAN/control` file to set the correct package name, version, architecture, maintainer, and description.

`control` file example:
```txt
Package: python
Version: 3.11.10
Architecture: armhf
Maintainer: elPytel <jaroslav.korner1@gmail.com>
Section: interpreters
Priority: optional
Description: Python 3.11.10 for Nokia N900

```

### Move the python binaries
After compiling Python, you need to move the binaries to the correct location in the package structure.
Move the python binaries to the `python_3.11.10_armhf/usr/bin/` directory:

### Build the Debian package
Run the helper script `build_python_deb.sh` (again) to create the Debian package:
```bash
./build_python_deb.sh
```

This will create a `.deb` file in the current directory, which you can then install on your N900 device.

### Copy the package to N900 over SSH
You can use `scp` to copy the package to your N900 device:
```bash
scp python_3.11.10_armhf.deb user@<n900_ip>:/home/user/MyDocs/
```