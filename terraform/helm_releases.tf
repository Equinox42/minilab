resource "helm_release" "argocd" {
  depends_on       = [helm_release.cert-manager]
  atomic           = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.4.4"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("${path.module}/../helm/argocd/argocd-values.yaml")]
}

