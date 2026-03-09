#!/bin/bash

# Check if the script is being run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges. Please run it with sudo."
    exit 1
fi

# Update package lists
echo "Updating package lists..."
apt update -y

# Install required dependencies (including tools for adding a repository)
echo "Installing required dependencies..."
apt install -y wget curl gnupg lsb-release

# Download the latest Google Chrome .deb package
echo "Downloading Google Chrome .deb package..."
wget -q --show-progress https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/

# Install the .deb package using dpkg
echo "Installing Google Chrome..."
dpkg -i /tmp/google-chrome-stable_current_amd64.deb

# Fix missing dependencies if necessary
echo "Fixing missing dependencies..."
apt-get install -f -y

# Add Google's public key to verify the repository
echo "Adding Google's public key to the trusted keyring..."
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | tee /etc/apt/trusted.gpg.d/google.asc

# Add Google Chrome repository to apt sources
echo "Adding Google Chrome repository..."
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

# Update package lists again after adding the repository
echo "Updating package lists after adding the Google repository..."
apt update -y

# Clean up
echo "Cleaning up..."
rm -f /tmp/google-chrome-stable_current_amd64.deb

# Verify installation
echo "Google Chrome installation complete!"
google-chrome-stable --version
