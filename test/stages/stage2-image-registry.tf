module "gitops_image_registry" {
  source = "./module"

  /*gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  registry_server = module.icr.registry_server
  registry_user = module.icr.registry_user
  registry_password = module.icr.registry_password
  registry_namespace = module.icr.registry_namespace
  registry_url = module.icr.registry_url
  kubeseal_cert = module.gitops.sealed_secrets_cert
  server_name = module.gitops.server_name*/

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  registry_server = "quay.io"
  registry_user = "QUAY_CNTK_USERNAME"
  registry_password = "QUAY_CNTK_TOKEN"
  registry_namespace = "cloud-native-toolkit"
  registry_url = "https://quay.io/cloud-native-toolkit"
  kubeseal_cert = module.gitops.sealed_secrets_cert
  server_name = module.gitops.server_name
}
