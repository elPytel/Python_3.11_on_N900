#!/bin/bash
# By Pytel
# This script builds deb package for Python 3.11 for the Nokia N900

source .config

PYTHON_DEB_FOLDER="python_${PYTHON_VERSION}_armhf"
BIN_FOLDER="$PYTHON_DEB_FOLDER/usr/bin"
BIN_FILE="python3.11"
DEB_FILE="python_${PYTHON_VERSION}_armhf.deb"

if [ ! -d "$PYTHON_DEB_FOLDER/DEBIAN" ]; then
    mkdir -p "$PYTHON_DEB_FOLDER/DEBIAN"
    echo -e "${Yellow}Created directory $PYTHON_DEB_FOLDER/DEBIAN${NC}"
fi

if [ ! -d "$BIN_FOLDER" ]; then
    mkdir -p "$BIN_FOLDER"
    echo -e "${Yellow}Created directory $BIN_FOLDER${NC}"
fi

if [ ! -f "$PYTHON_DEB_FOLDER/DEBIAN/control" ]; then
    echo -e "${Red}Error: control file not found in $PYTHON_DEB_FOLDER/DEBIAN!${NC}"
    exit 1
fi

if [ ! -f "$BIN_FOLDER/$BIN_FILE" ]; then
    echo -e "${Red}Error: $BIN_FILE not found in $BIN_FOLDER!${NC}"
    echo -e "${Cyan}Please run compile_python.sh first to build Python 3.11!${NC}"
    echo -e "And move all the compiled bin files: $BIN_FILE to $BIN_FOLDER"
    exit 1
fi

echo -e "${Cyan}Setting permissions for package files...${NC}"
chmod 755 "$BIN_FOLDER/$BIN_FILE"
chmod 644 "$PYTHON_DEB_FOLDER/DEBIAN"/*

echo -e "${Cyan}Building Debian package for Python ${PYTHON_VERSION}...${NC}"
dpkg-deb --build $PYTHON_DEB_FOLDER

if [ $? -ne 0 ]; then
    echo -e "${Red}Error building Debian package!${NC}"
    exit 1
fi

echo -e "${Green}Debian package built successfully!${NC}"
echo -e "${Cyan}Debian package location: $DEB_FILE${NC}"
echo -e "${Cyan}Package information:${NC}"
dpkg-deb --info $DEB_FILE

echo -e "${Cyan}Package contents:${NC}"
dpkg-deb --contents $DEB_FILE

echo -e "${Green}Done!${NC}"
# END