module "k8s_cluster" {
  source = "./modules/kubernetes-cluster"
  
  cluster_name = "management"
  username         = var.username
  template_id      = var.template_id
  kubernetes_nodes = var.kubernetes_nodes
  ssh_key          = var.ssh_key
  gateway          = var.gateway
  proxmox_node     = var.proxmox_node
}


resource "local_file" "k0sctl_config" {
  filename = "${path.module}/../k0s/generated/k0sctl-${module.k8s_cluster.cluster_name}.yaml"
  file_permission = "0600"

  content = templatefile("${path.module}/../k0s/k0sctl.yaml.tftpl", {
    cluster_name         = "mini-k0s-${module.k8s_cluster.cluster_name}"
    ssh_user             = var.username
    ssh_private_key_path = var.ssh_private_key_path
    k0s_version          = var.k0s_version
    nodes                = var.kubernetes_nodes
    proxmox_csi_region = var.proxmox_csi_region
    proxmox_csi_zone   = var.proxmox_csi_zone
  })
}

resource "terraform_data" "k0s_bootstrap" {
  depends_on = [module.k8s_cluster, local_file.k0sctl_config]

  triggers_replace = [
    local_file.k0sctl_config.content
  ]

  provisioner "local-exec" {
    command = "bash ${abspath("${path.module}/../k0s/k0s_init.sh")}"
    environment = {
      MANIFEST_PATH = abspath(local_file.k0sctl_config.filename)
      CLUSTER_NAME  = "mini-k0s-${module.k8s_cluster.cluster_name}"
      NODE_IPS      = join(",", module.k8s_cluster.all_ips)
      SSH_USER      = var.username
      SSH_KEY_PATH  = var.ssh_private_key_path
      DEBUG         = true
    }
  }
}