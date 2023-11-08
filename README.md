# Tailscal-Proxmox-LXC-Script
Script to make changes to LXC config on Proxmox for Tailscale

Unprivileged LXC containers in Proxmox won't work with Tailscale.

https://tailscale.com/kb/1130/lxc-unprivileged/

They require changes to the LXC config file in Proxmox. This script makes the changes and reboots the container for you.

## Usage

Supply the script the IP/hostname, username, and target container ID.
It will prompt for the password. 

```
./lxc-ts-fix.sh -h
Usage: ./lxc-ts-fix.sh [-u username] [-l ip] [-i Container-id]

This script adds the required config changes to LXC file and then reboots the container

Options:
  -u  Specify the username for Proxmox.
  -l  Specify the IP or hostname for Proxmox.
  -i  Specify the LXC container ID.
  -h  Display this help message.
```

```
./lxc-ts-fix.sh -u root -l 10.10.10.10 -i 106
```
