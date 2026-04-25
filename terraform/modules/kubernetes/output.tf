output "cluster_name" {
  description = "Name of the deployed cluster"
  value       = var.cluster_name
}
output "node_ips" {
  description = "Map of node names to their IP addresses"
  value       = { for name, node in var.kubernetes_nodes : name => node.ip }
}

output "all_ips" {
  description = "List of all node IPs (for SSH known_hosts cleanup)"
  value       = [for node in var.kubernetes_nodes : node.ip]
}

output "control_plane_ip" {
  description = "IP address of the first controller node"
  value       = [for node in var.kubernetes_nodes : node.ip if node.role == "controller"][0]
}
