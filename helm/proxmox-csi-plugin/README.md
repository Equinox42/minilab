## About Proxmox CSI
Every informations needed to make the plugin work are available at the following link : https://github.com/sergelogvinov/proxmox-csi-plugin


tldr : 

- Make sure to use SCSCI Controller to VirtIO SCSI Single for the VMs.
- Make sure to create the resources needed within the `proxmox_csi.tf` file.
- Make sure to label the nodes of your Kubernetes cluster :

```bash
kubectl label nodes region1-node-1 topology.kubernetes.io/region=#Proxmox Cluster Name
kubectl label nodes region1-node-1 topology.kubernetes.io/zone=#Proxmox Node Name
```


- Modify the `proxmox-csi-values.yaml` to suits your needs

```bash
kubectl create namespace csi-proxmox
helm upgrade -i -n csi-proxmox -f proxmox-csi-values.yaml proxmox-csi-plugin oci://ghcr.io/sergelogvinov/charts/proxmox-csi-plugin
```
