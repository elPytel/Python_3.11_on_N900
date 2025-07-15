# Python 3.11 Compilation Guide for N900

Run the script `compile_python.sh` to compile Python 3.11 for the N900 device. This script automates the process of downloading, configuring, and compiling Python 3.11.

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

## Resources
- [Build python 3.11 on raspberry pi from source](https://cloasdata.de/?p=352)