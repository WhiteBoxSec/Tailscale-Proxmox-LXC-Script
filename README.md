# Tailscal-Proxmox-LXC-Script
Script to make changes to LXC config on Proxmox for Tailscale

Unprivileged LXC containers in Proxmox won't work with Tailscale.

https://tailscale.com/kb/1130/lxc-unprivileged/

They require changes to the LXC config file in Proxmox. This script makes the changes for you.

## Usage

Supply the script the IP/hostname, username, password, and target container ID. 

```
```
