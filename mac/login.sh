#!/bin/bash

echo ".........................................................."
echo "Fetching VNC Server Details..."

# Debugging: Print the log contents
echo "Checking Pinggy output..."
cat pinggy.log

# Extract and print the public VNC address
if [ -s vnc_address.txt ]; then
  VNC_URL=$(cat vnc_address.txt)
  echo "Public VNC Address: $VNC_URL"
else
  echo "Public VNC Address: [ERROR: Could not retrieve address]"
fi

echo "Username: runneradmin"
echo "Password: P@ssw0rd!"
