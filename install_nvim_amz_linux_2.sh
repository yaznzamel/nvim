#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Exit if any command in a pipeline fails
set -x  # Debug mode (prints executed commands)

# Define versions
CMAKE_VERSION="3.31.4"
NEOVIM_REPO="https://github.com/neovim/neovim"

echo "🔹 Updating system packages..."
sudo yum update -y

echo "🔹 Installing required dependencies..."
sudo yum install -y openssl-devel gcc gcc-c++ make ncurses-devel git wget

# Check if CMake is installed and version is lower than required
if cmake --version 2>/dev/null | grep -q "2.8"; then
    echo "🔹 Old CMake version detected. Upgrading to ${CMAKE_VERSION}..."
    
    # Download and build latest CMake
    wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz"
    tar -xvzf "cmake-${CMAKE_VERSION}.tar.gz"
    cd "cmake-${CMAKE_VERSION}"

    echo "🔹 Building CMake..."
    ./bootstrap
    make -j$(nproc)  # Use all CPU cores for faster compilation
    sudo make install

    # Modify PATH to include new CMake
    export PATH="/usr/local/bin:$PATH"
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc

    cd ..
    rm -rf "cmake-${CMAKE_VERSION}" "cmake-${CMAKE_VERSION}.tar.gz"
else
    echo "✅ CMake is already up-to-date."
fi

# Build Neovim
echo "🔹 Cloning Neovim repository..."
git clone --depth 1 "$NEOVIM_REPO"
cd neovim

echo "🔹 Checking out stable version..."
git checkout stable

echo "🔹 Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "✅ Neovim installation completed successfully!"
echo "🔹 Run 'nvim' to start using Neovim."

