module "gitops_image_registry" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  registry_server = module.icr.registry_server
  registry_user = module.icr.registry_user
  registry_password = module.icr.registry_password
  registry_namespace = module.icr.registry_namespace
  registry_url = module.icr.registry_url
  kubeseal_cert = module.argocd-bootstrap.sealed_secrets_cert
  server_name = module.gitops.server_name
}
