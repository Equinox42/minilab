module "k8s_cluster_prod" {

  source = "./modules/kubernetes-cluster"
  environment = "prod"
  username = var.username
  template_id = var.template_id
  kubernetes_nodes = var.kubernetes_nodes_prod
  ssh_key = var.ssh_key
  gateway = var.gateway
  proxmox_node = var.proxmox_node

}

module "k8s_cluster_dev" {

  count = var.enabled_dev_cluster ? 1 : 0
  source = "./modules/kubernetes-cluster"
  environment = "dev"
  username = var.username
  template_id = var.template_id
  kubernetes_nodes = var.kubernetes_nodes_dev
  ssh_key = var.ssh_key
  gateway = var.gateway
  proxmox_node = var.proxmox_node

}

