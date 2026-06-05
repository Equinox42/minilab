#https://image-builder.sigs.k8s.io/capi/providers/proxmox

When using image-builder the following variables must be set : 

```bash
export PROXMOX_URL="https://X.X.X.X:8006/api2/json/"
export PROXMOX_USERNAME="imagebuilder@pve!imagebuilder"
export PROXMOX_TOKEN="replace_with_token_value"
export PROXMOX_NODE=""
export PROXMOX_ISO_POOL=""
export PROXMOX_BRIDGE=""
export PROXMOX_STORAGE_POOL=""
#export PACKER_FLAGS="-var disk_format=raw" 
#export PACKER_LOG=1  Might help if need troubleshooting, also tailing the following file on the hypervisor : tail -f /var/log/pveproxy/access.log
```