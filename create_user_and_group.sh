#!/usr/bin/env bash

# USAGE: ./create_user_and_group.sh myuser mygroup

# Check if root is executing the script
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if exactly 2 arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <groupname>"
    exit 1
fi

# Assigning provided arguments to variables
username="$1"
groupname="$2"

# Check if the group already exists
if grep -q "^$groupname:" /etc/group; then
    echo "Group $groupname already exists."
else
    # Create the group
    groupadd "$groupname"
    echo "Group $groupname created."
fi

# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User $username already exists."
else
    # Create the user with the specified group and home directory
    useradd -m -d "/home/$username" -g "$groupname" --shell /bin/bash "$username"
    echo "${username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/"$username"
    echo "User $username created with home directory /home/$username."
fi
