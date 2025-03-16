#!/bin/bash

# Disable Spotlight indexing
sudo mdutil -i off -a

# Create new account
sudo dscl . -create /Users/runneradmin
sudo dscl . -create /Users/runneradmin UserShell /bin/bash
sudo dscl . -create /Users/runneradmin RealName Runner_Admin
sudo dscl . -create /Users/runneradmin UniqueID 1001
sudo dscl . -create /Users/runneradmin PrimaryGroupID 80
sudo dscl . -create /Users/runneradmin NFSHomeDirectory /Users/runneradmin
sudo dscl . -passwd /Users/runneradmin P@ssw0rd!
sudo createhomedir -c -u runneradmin > /dev/null
sudo dscl . -append /Groups/admin GroupMembership runneradmin

# Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

# Start VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# Install Pinggy
brew install openssh

# Start Pinggy TCP tunnel in the background
echo "Starting Pinggy tunnel..."
nohup ssh -p 443 -R0:localhost:5900 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 NR1iM59Qqvp+tcp@free.pinggy.io > pinggy.log 2>&1 &

# Wait for the tunnel to establish (give it more time)
sleep 15  # Increase sleep time to ensure tunnel is fully up

# Check if the Pinggy tunnel is running and extract the VNC address
if ps aux | grep "[s]sh -p 443" > /dev/null; then
    # Debug: Print the output from the Pinggy tunnel log
    echo "Pinggy Output:"
    cat pinggy.log

    # Extract the VNC address dynamically from the output (matches the pattern tcp://<host>:<port>)
    vnc_address=$(grep -o 'tcp://[^ ]*' pinggy.log)

    # Check if the VNC address was found
    if [ -z "$vnc_address" ]; then
        echo "Error: VNC address not found."
    else
        echo "Public VNC Address: $vnc_address"
    fi
else
    echo "Error: Pinggy tunnel is not running."
fi
