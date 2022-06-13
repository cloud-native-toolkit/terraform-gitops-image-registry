
resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        name        = module.gitops_image_registry.name
        branch      = module.gitops_image_registry.branch
        namespace   = module.gitops_image_registry.namespace
        server_name = module.gitops_image_registry.server_name
        layer       = module.gitops_image_registry.layer
        layer_dir   = module.gitops_image_registry.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_image_registry.layer == "services" ? "2-services" : "3-applications")
        type        = module.gitops_image_registry.type
      })
    }
  }
}
