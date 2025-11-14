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
## Handling Sensitive Variables

I manage sensitive variables with the help of direnv, which automatically loads environment variables defined in a .envrc file when entering a directory.

```
# .envrc
export TF_VAR_api_token="pve!terraform@pve!xxxxxxxx"
export TF_VAR_proxmox_host="https://192.168.x.x:8006/"
export TF_VAR_ssh_key="$(< ~/.ssh/id_rsa.pub)"
export TF_VAR_username="user inside the VMs"
```

Read more at https://direnv.net/
