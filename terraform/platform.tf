resource "helm_release" "argocd" {
  depends_on = [ infisical_identity_kubernetes_auth.this ]
  atomic           = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.5.13"
  namespace        = "argocd"
  create_namespace = true
  lifecycle {
    ignore_changes = all
  }
}

resource "kubectl_manifest" "app_of_apps" {
  depends_on = [ helm_release.argocd ]
  yaml_body = file("${path.module}/../kubernetes/app-of-apps.yaml")
}
