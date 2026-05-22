## Steps required to use Terraform with Proxmox

- Create a user : 
```bash
sudo pveum user add terraform@pve
```
- Create a role for the terraform user :
```bash
sudo pveum role add Terraform -privs "list of privileges"
```

Refer to privileges documentation : https://pve.proxmox.com/pve-docs/pveum.1.html#_privileges

- Assign the role to the user : 
```bash
sudo pveum aclmod / -user terraform@pve -role Terraform
```
- Create the API Token 
```bash
sudo pveum user token add terraform@pve provider --privsep=0
```