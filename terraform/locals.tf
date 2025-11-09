locals {
  k8s_nodes = {
    "control-plane" = { ip = "X.X.X.X", cpu = 2, memory = 4096 }
    "worker-1"      = { ip = "X.X.X.X", cpu = 3, memory = 8196 }
    "worker-2"      = { ip = "X.X.X.X", cpu = 3, memory = 8196 }
    "worker-3"      = { ip = "X.X.X.X", cpu = 3, memory = 8196 }
  }
}
