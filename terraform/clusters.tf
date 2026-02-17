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

# Development cluster: Used exclusively to provision ephemeral machines for manual testing.

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

resource "terraform_data" "k0s_bootstrap" {
  depends_on = [module.k8s_cluster_prod]

  provisioner "local-exec" {
    command = "bash ${path.module}/../k0s/k0s_init.sh"
    environment = {
      MANIFEST_PATH = "${path.module}/../k0s/k0sctl.yaml"
      CLUSTER_NAME = "mini-k0s-${module.k8s_cluster_prod.environment}"
      SSH_PRIVATE_KEY_PATH = var.ssh_private_key_path
      SSH_USER = var.username
      CONTROLLER_IP = var.kubernetes_nodes_prod["control-plane"].ip
      WORKER1_IP = var.kubernetes_nodes_prod["worker-1"].ip
      WORKER2_IP = var.kubernetes_nodes_prod["worker-2"].ip
      WORKER3_IP = var.kubernetes_nodes_prod["worker-3"].ip
    }
  }
}