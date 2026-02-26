resource "helm_release" "metallb" {
  depends_on       = [terraform_data.k0s_bootstrap]
  atomic           = true
  name             = "minimetallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = "0.15.3"
  namespace        = "metallb-system"
  create_namespace = true
}

resource "kubernetes_manifest" "metallb_ip_pool" {
  depends_on = [helm_release.metallb]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "homelab-pool"
      namespace = "metallb-system"
    }
    spec = {
      addresses = [var.metallb_adress_pool]
    }
  }
}

resource "kubernetes_manifest" "metallb_l2_adv" {
  depends_on = [kubernetes_manifest.metallb_ip_pool]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = "homelab-adv"
      namespace = "metallb-system"
    }
    spec = {
      ipAddressPools = ["homelab-pool"]
    }
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_manifest.metallb_l2_adv]
  atomic           = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.4.4"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("${path.module}/../helm/argocd/argocd-values.yaml")]
}