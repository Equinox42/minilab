<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.78.2 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datastore_id"></a> [datastore\_id](#input\_datastore\_id) | n/a | `string` | `"local-lvm"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | cluster environment | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `list(string)` | `[]` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | IP of the gateway | `string` | n/a | yes |
| <a name="input_kubernetes_nodes"></a> [kubernetes\_nodes](#input\_kubernetes\_nodes) | Nodes Configuration | <pre>map(object({<br/>    ip     = string<br/>    cpu    = number<br/>    memory = number<br/>  }))</pre> | n/a | yes |
| <a name="input_proxmox_node"></a> [proxmox\_node](#input\_proxmox\_node) | Proxmox node where VMs will be deployed | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH public key to inject into the VM | `string` | n/a | yes |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | Template VM ID to clone | `number` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->