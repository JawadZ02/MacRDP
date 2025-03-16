#!/bin/bash

echo ".........................................................."
echo "Fetching VNC Server Details..."

# Extract the public address from Pinggy
if [ -s vnc_address.txt ]; then
  VNC_URL=$(cat vnc_address.txt)
  echo "Public VNC Address: $VNC_URL"
else
  echo "Public VNC Address: [ERROR: Could not retrieve address]"
fi

echo "Username: runneradmin"
echo "Password: P@ssw0rd!"
