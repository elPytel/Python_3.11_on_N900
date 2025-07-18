#!/bin/bash
# By Pytel
# This script compiles Python 3.11 for the Nokia N900

source .config

function cleanup {
    echo -e "${Yellow}Cleaning up...${NC}"
    rm -f $PYTHON_TAR
    if [ -d "Python-$PYTHON_VERSION" ]; then
        rm -rf "Python-$PYTHON_VERSION"
    fi
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi
    echo -e "${Cyan}Removed temporary files and directories.${NC}"
    echo -e "${Green}Cleanup completed!${NC}"
}

function install_python_3.11 {
    echo -e "${Cyan}Installing Python 3.11...${NC}"
    sudo add-apt-repository ppa:deadsnakes/ppa
    xargs sudo apt-get -y install < $apt_dependencies_python_3_11
    if [ $? -ne 0 ]; then
        echo -e "${Red}Error installing Python 3.11 dependencies!${NC}"
        exit 1
    fi
    echo -e "${Green}Python 3.11 dependencies installed successfully!${NC}"
}

# Install apt dependencies
echo -e "${Cyan}Installing apt dependencies...${NC}"
sudo apt-get update
if [ ! -f $apt_dependencies ]; then
    echo -e "${Red}Error: $apt_dependencies file not found!${NC}"
    exit 1
fi
xargs sudo apt-get -y install < $apt_dependencies
echo -e "${Green}Apt dependencies installed successfully!${NC}"


# Check if Python 3.11 is installed
if ! command -v python3.11 &> /dev/null; then
    echo -e "${Red}Python 3.11 is not installed!${NC}"
    install_python_3.11
else
    echo -e "${Green}Python 3.11 is already installed!${NC}"
fi

# Download Python source code
echo -e "${Cyan}Downloading Python source code...${NC}"

if [ -f $PYTHON_TAR ]; then
    echo -e "${Yellow}$PYTHON_TAR already exists. Skipping download.${NC}"
else
    echo -e "${Cyan}Downloading ${Blue}$PYTHON_TAR...${NC}"
    wget $PYTHON_SOURCE -O $PYTHON_TAR
    if [ $? -ne 0 ]; then
        echo -e "${Red}Error downloading ${Blue}$PYTHON_TAR!${NC}"
        exit 1
    fi
    echo -e "${Green}Download completed!${NC}"
fi

# Extract Python source code
echo -e "${Cyan}Extracting Python source code...${NC}"
tar xzf $PYTHON_TAR


cd "Python-$PYTHON_VERSION"

make distclean
if [ ! -d $OPENSSL_ARM_PATH ]; then
    echo -e "${Red}Error: OpenSSL for ARM not found in $OPENSSL_ARM_PATH!${NC}"
    #exit 1
fi

echo -e "${Cyan}Configuring Python for ARM...${NC}"

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

if [ $? -ne 0 ]; then
    echo -e "${Red}Error configuring Python!${NC}"
    exit 1
fi

# TODO: --with-openssl=$OPENSSL_ARM_PATH is not working, need to fix it later
# remove: --without-ensurepip \

# Compile Python
echo -e "${Cyan}Compiling Python...${NC}"
echo -e "${Yellow}Number of processors: ${Blue}$(nproc)${NC}"

make -j$(nproc)

echo -e "${Cyan}Installing to $INSTALL_DIR...${NC}"
make install DESTDIR="$INSTALL_DIR"

cd ..

echo -e "${Green}Python 3.11 compiled and installed successfully!${NC}"
echo -e "${Cyan}Python executable is located at: ${Blue}$INSTALL_DIR/bin/python3.11${NC}"
echo -e "${Cyan}Format of the Python executable:${NC}"
file $INSTALL_DIR/bin/python3.11

#trap cleanup EXIT
echo -e "${Green}Done!${NC}"