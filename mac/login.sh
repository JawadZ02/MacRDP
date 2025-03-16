#!/bin/bash

echo ".........................................................."
echo "Fetching VNC Server Details..."

# Extract the generated public address from Pinggy
PINGGY_URL=$(grep -o 'https://[^ ]*' pinggy.txt)

echo "Public VNC Address: $PINGGY_URL"
echo "Username: runneradmin"
echo "Password: P@ssw0rd!"
