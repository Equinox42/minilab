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
