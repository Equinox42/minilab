resource "helm_release" "argocd" {
  name       = "mini-argocd"
  repository = "argo"
  chart      = "argo-cd"
  version    = "9.4.2"
}