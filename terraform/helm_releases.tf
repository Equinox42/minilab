resource "helm_release" "argocd" {
  atomic           = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.5.13"
  namespace        = "argocd"
  create_namespace = true
}