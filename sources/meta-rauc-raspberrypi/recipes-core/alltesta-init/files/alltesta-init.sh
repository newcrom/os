#!/bin/bash

echo "Script started"

# Check and create symbolic link if it doesn't exist
SYMLINK_PATH="/etc/udev/rules.d/80-net-setup-link.rules"
echo "Checking for symbolic link at $SYMLINK_PATH"
if [ ! -L "$SYMLINK_PATH" ]; then
    ln -s /dev/null "$SYMLINK_PATH"
    if [ $? -ne 0 ]; then
        echo "Failed to create symbolic link" >&2
        exit 1
    fi
    echo "Symbolic link created"
else
    echo "Symbolic link already exists"
fi

# Process cpuinfo
echo "Processing /proc/cpuinfo"
# Check if /data/fakecpuinfo already exists
if [ ! -f /data/fakecpuinfo ]; then
    if cat /proc/cpuinfo > /data/fakecpuinfo; then
        echo "Hardware : BCM2835" >> /data/fakecpuinfo
        if [ $? -ne 0 ]; then
            echo "Failed to append hardware info to /data/fakecpuinfo" >&2
            exit 1
        fi
        echo "Appended hardware info to /data/fakecpuinfo"
    else
        echo "Failed to write /proc/cpuinfo to /data/fakecpuinfo" >&2
        exit 1
    fi
else
    echo "/data/fakecpuinfo already exists. Skipping creation."
fi

# Check if serial.txt already exists before running the Python script
echo "Checking for existing /data/root/serial.txt"
if [ ! -f /data/root/serial.txt ]; then
    if python3 /usr/bin/device-get-serial.py; then
        echo "Executed Python script successfully"
    else
        echo "Failed to execute Python script" >&2
        exit 1
    fi
else
    echo "/data/root/serial.txt already exists. Skipping Python script execution."
fi

# Read new hostname, check for existence
echo "Checking for new hostname in /data/root/serial.txt"
if [ -f /data/root/serial.txt ]; then
    NEW_HOSTNAME=$(cat /data/root/serial.txt)
else
    echo "serial.txt not found" >&2
    exit 1
fi

OLD_HOSTNAME="raspberrypi3-64"

# Set new hostname, check if successful
echo "Setting new hostname to $NEW_HOSTNAME"
hostnamectl set-hostname "$NEW_HOSTNAME"
if [ $? -ne 0 ]; then
    echo "Failed to set hostname" >&2
    exit 1
fi
echo "New hostname set"

# Update /etc/hosts file safely
echo "Updating /etc/hosts file"
if grep -q "$OLD_HOSTNAME" /etc/hosts; then
    sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
    echo "Updated /etc/hosts file successfully"
else
    echo "Old hostname not found in /etc/hosts" >&2
    exit 1
fi

# Create directory if not exists
echo "Creating directory /etc/rancher/k3s/"
mkdir -p /etc/rancher/k3s/

# Start and enable k3s-agent service, check if successful
echo "Starting and enabling k3s-agent service"
systemctl start k3s-agent
systemctl enable k3s-agent.service
if [ $? -ne 0 ]; then
    echo "Failed to start or enable k3s-agent.service" >&2
    exit 1
fi
echo "k3s-agent service started and enabled"

echo "Script executed successfully"
