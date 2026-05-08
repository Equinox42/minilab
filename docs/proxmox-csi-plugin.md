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


```yaml
# proxmox-csi-values.yaml
# default values are avalaible at this link : https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/charts/proxmox-csi-plugin/values.yaml

config:
  clusters:
    - url: https://x.x.x.x:8006/api2/json
      insecure: true
      token_id: "kubernetes-csi@pve!csi"
      # The token secret should be present in your terraform state if you used terraform to provision the resources
      token_secret: ""
      # Proxmox cluster name, find it in the webui > Datacenter > Cluster > Cluster-Information
      region: ""

# Define the storage classes
storageClass:
  - name: proxmox-data-xfs
  # See Datacenter > Storage
    storage: local-lvm
    reclaimPolicy: Delete
    fstype: xfs
    ssd: true 
    annotations:
      storageclass.kubernetes.io/is-default-class: "true"

node:
  # This key is not required if using kubespray/kubeadm
  kubeletDir: /var/lib/k0s/kubelet
```

```bash
kubectl create namespace csi-proxmox
helm upgrade -i -n csi-proxmox -f proxmox-csi-values.yaml proxmox-csi-plugin oci://ghcr.io/sergelogvinov/charts/proxmox-csi-plugin
```
