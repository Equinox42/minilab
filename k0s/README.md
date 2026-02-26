## About k0s & k0sctl

k0s is a certified Kubernetes distribution that works on different environments : bare-metal, on-premises, IoT, public as well as private clouds, etc. It's 100% open source & free.

More detail about the project : https://k0sproject.io/

Lightning talk about the k0s family at the Cloud Native Days France : https://www.youtube.com/watch?v=Edo3e7KFqN8&feature=youtu.be

k0sctl is a command-line tool for bootstrapping and managing k0s clusters. k0sctl connects to the provided hosts using SSH and gathers information on the hosts, with which it forms a cluster by configuring the hosts, deploying k0s, and then connecting the k0s nodes together.



## Variables validation & Manual Testing

k0sctl configuration supports bash-like expressions (e.g., `${CONTROLLER_IP}`), allowing for dynamic infrastructure provisioning.

### 1. Rendering & Validation (Optional)

You can make use of the command `envsubst` to verify your environment variables (it is usually already available on Linux distribution and macOS) it will render the file directly in the stdout.

```bash
envsubst < k0s_cluster.yaml
```

### 2.Bootstrapping the Cluster

Once your variables are properly exported in your shell, proceed to the installation

```bash
k0sctl apply --config k0s_cluster.yaml --no-wait
```

### 3. Fetching the Kubeconfig
Once deployed, the Kubernetes API configuration is generated at `/var/lib/k0s/pki/admin.conf` on the control plane. You can easily fetch it to your local machine with the following commmand :

```bash
k0sctl kubeconfig --config k0s_cluster.yaml > ~/.kube/k0s_cluster.config
```

Add it to the `KUBECONFIG` variable : 

```bash
export KUBECONFIG=~/.kube/already_existing_cluster.config:~/.kube/k0s_cluster.config
```
