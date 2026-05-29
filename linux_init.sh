#!/bin/bash

echo "====================================="
echo "Step 1: Update APT sources"
echo "====================================="
sudo apt update -y

echo -e "\n====================================="
echo "Step 2: Install required tools"
echo "====================================="
sudo apt install git python3 uuid-dev nasm bison flex build-essential -y

echo -e "\n====================================="
echo "Step 3: Map python to python3"
echo "====================================="
if ! command -v python &>/dev/null; then
    sudo ln -s /usr/bin/python3 /usr/bin/python
    echo "Python3 has been mapped to python."
else
    echo "Python is already mapped to python3."
fi

echo -e "\n====================================="
echo "Step 4: Update submodule in root path"
echo "====================================="
git submodule update --init \
  acpica \
  edk2-libc \
  edk2 \
  Individual/Doc/Robin/uefi-practical-programming \
  Individual/Doc/Robin/uefi-explorer \
  Individual/Doc/Kostr/UEFI-Lessons \
  Individual/Doc/jiangwei/edk2-beni \
  Tools/DebugTools/binarly-io/efiXplorer

echo -e "\n====================================="
echo "Step 5: Update submodule in edk2"
echo "====================================="
cd edk2
git submodule update --init

echo -e "\n====================================="
echo "Step 6: Build EDK2 BaseTools"
echo "====================================="
make -C BaseTools

echo -e "\n====================================="
echo "Step 7: Build ACPICA"
echo "====================================="
cd ..
make -C acpica

echo -e "\n====================================="
echo "Initialization completed under Linux"
echo "====================================="