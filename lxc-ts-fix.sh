#!/bin/bash

# Script to make changes to LXC container to allow Tailscale connections
# https://tailscale.com/kb/1130/lxc-unprivileged/

# This adds the required config changes to LXC file and then reboots the container.

# Display usage information
usage() {
    echo "Usage: $0 [-u username] [-l ip] [-i Container-id]"
    echo
    echo -e "\e[31mThis script adds the required config changes to LXC file and then reboots the container\e[0m"
    echo 
    echo "Options:"
    echo "  -u  Specify the username for Proxmox."
    echo "  -l  Specify the IP or hostname for Proxmox."
    echo "  -i  Specify the LXC container ID."
    echo "  -h  Display this help message."
    exit 1
}

# Parse command-line arguments for username, password, ip, and id
while getopts u:p:l:i:h flag; do
    case "${flag}" in
        u) username=${OPTARG} ;;
        p) password=${OPTARG} ;;
        l) ip=${OPTARG} ;;
        i) id=${OPTARG} ;;
        h) usage ;;
        *) usage ;;
    esac
done

# If variables are not provided as command-line arguments, prompt the user for them
# Always prompt for password.
if [[ -z "$username" ]]; then
  read -r -p "Enter Proxmox username: " username
fi
if [[ -z "$password" ]]; then
  read -r -s -p "Enter Proxmox password: " password
  echo
fi
if [[ -z "$ip" ]]; then
  read -r -p "Enter the Proxmox IP: " ip
fi
if [[ -z "$id" ]]; then
  read -r -p "Enter the LXC ID: " id
fi

# Check if all required variables are provided
if [[ -z "$username" || -z "$password" || -z "$ip" || -z "$id" ]]; then
  echo "Error: You must provide a username, password, IP, and ID."
  exit 1
fi

# Proxmox LXC config changes.
read -d '' config << "BLOCK"
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
BLOCK

echo  -e "\e[36mConnecting to Proxmox server and adding lines to config.\e[0m"
sleep 2
sshpass -p "$password" ssh $username@$ip "echo \"$config\" >> \"/etc/pve/lxc/$id.conf\""
sleep 2
echo -e "\e[36mRestarting LXC container to make the changes.\e[0m"
sleep 2 
sshpass -p "$password" ssh $username@$ip "lxc-stop -r -n $id"
sleep 2 
echo -e "\e[32mTailscale should work on the container now!\e[0m"
echo -e "\e[32mGo forth and VPN!\e[0m"
