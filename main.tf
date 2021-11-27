locals {
  bin_dir = module.setup_clis.bin_dir
  name      = "image-registry"
  tmp_dir   = "${path.cwd}/.tmp/${local.name}/secrets"
  yaml_dir  = "${path.cwd}/.tmp/${local.name}/yaml"
  layer     = "infrastructure"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
  registry_type = replace(length(regexall(".*icr.io$", var.registry_server)) > 0 ? "icr_io" : var.registry_server, ".", "_")
  image_urls = {
    icr_io = "data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIGlkPSJMYXllcl8xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHg9IjAiIHk9IjAiIHdpZHRoPSI2NCIgaGVpZ2h0PSI2NCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+PHN0eWxlPi5zdDB7ZmlsbDojOWU3YmZmfS5zdDF7ZmlsbDojMGYzNjU5fTwvc3R5bGU+PHBhdGggY2xhc3M9InN0MCIgZD0iTTE1LjggNTUuNmwtMTEuNi04Yy44LjUgMS44LjYgMi45LjJsMjYuNy0xMC4xYzIuMy0uOSA0LjEtMy42IDQuMS02VjMuMmMwLTEuMi0uNS0yLjEtMS4yLTIuN2wxMS41IDcuOWMuNy41IDEuMiAxLjQgMS4yIDIuN3YyOC41YzAgMi40LTEuOSA1LjEtNC4xIDZMMTguNyA1NS44Yy0xLjIuNC0yLjIuMy0yLjktLjJ6Ii8+PHBhdGggY2xhc3M9InN0MCIgZD0iTTU5LjggMTYuNGwtNi41LTQuNWMuNy41IDEuMiAxLjQgMS4yIDIuN3YyOC41YzAgMi40LTEuOSA1LjEtNC4xIDZMMjMuNyA1OS4yYy0xLjEuNC0yLjIuMy0yLjktLjJsNi41IDQuNWMuNy41IDEuOC42IDIuOS4ybDI2LjctMTAuMWMyLjMtLjkgNC4xLTMuNiA0LjEtNlYxOWMwLTEuMi0uNS0yLjEtMS4yLTIuNnoiLz48cGF0aCBjbGFzcz0ic3QxIiBkPSJNNDguMiA4LjRjLS43LS41LTEuOC0uNi0yLjktLjJMMTguNyAxOC40Yy0yLjMuOS00LjEgMy42LTQuMSA2djI4LjVjMCAxLjIuNSAyLjEgMS4yIDIuN0w0LjMgNDcuN0MzLjUgNDcuMSAzIDQ2LjIgMyA0NVYxNi41YzAtMi40IDEuOS01LjEgNC4xLTZMMzMuOC4zYzEuMS0uNCAyLjItLjMgMi45LjJsMTEuNSA3Ljl6Ii8+PHBhdGggY2xhc3M9InN0MSIgZD0iTTIwLjggNTljLS43LS41LTEuMi0xLjQtMS4yLTIuN1YyNy44YzAtMi40IDEuOS01LjEgNC4xLTZsMjYuNy0xMC4xYzEuMS0uNCAyLjItLjMgMi45LjJsNi41IDQuNWMtLjctLjUtMS44LS42LTIuOS0uMkwzMC4yIDI2LjNjLTIuMy45LTQuMSAzLjYtNC4xIDZ2MjguNWMwIDEuMi41IDIuMSAxLjIgMi43TDIwLjggNTl6Ii8+PC9zdmc+"
    quay_io = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjUwMCIgaGVpZ2h0PSIyMzA1IiB2aWV3Qm94PSIwIDAgMjU2IDIzNiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCI+PHBhdGggZD0iTTIwMC4xMzQgMGw1NS41NTUgMTE3LjUxNC01NS41NTUgMTE3LjUxOGgtNDcuMjk1bDU1LjU1NS0xMTcuNTE4TDE1Mi44NCAwaDQ3LjI5NXpNMTEwLjA4IDk5LjgzNmwyMC4wNTYtMzguMDkyLTIuMjktOC44NjhMMTAyLjg0NyAwSDU1LjU1Mmw0OC42NDcgMTAyLjg5OCA1Ljg4MS0zLjA2MnptMTcuNzY2IDc0LjQzM2wtMTcuMzMzLTM5LjAzNC02LjMxNC0zLjEwMS00OC42NDcgMTAyLjg5OGg0Ny4yOTVsMjUtNTIuODh2LTcuODgzeiIgZmlsbD0iIzQwQjRFNSIvPjxwYXRoIGQ9Ik0xNTIuODQyIDIzNS4wMzJMOTcuMjg3IDExNy41MTQgMTUyLjg0MiAwaDQ3LjI5NWwtNTUuNTU1IDExNy41MTQgNTUuNTU1IDExNy41MThoLTQ3LjI5NXptLTk3LjI4NyAwTDAgMTE3LjUxNCA1NS41NTUgMGg0Ny4yOTZMNDcuMjk1IDExNy41MTRsNTUuNTU2IDExNy41MThINTUuNTU1eiIgZmlsbD0iIzAwMzc2NCIvPjwvc3ZnPgo="
  }
  image_url = var.image_url != "" ? var.image_url : lookup(local.image_urls, local.registry_type, "")
  display_name = var.display_name != "" ? var.display_name : "Image Registry"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_secrets {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-secrets.sh '${var.namespace}' '${local.tmp_dir}'"

    environment = {
      SERVER = var.registry_server
      USERNAME = var.registry_user
      PASSWORD = var.registry_password
      REGISTRY_NAMESPACE = var.registry_namespace
    }
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secrets]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git?ref=v1.0.0"

  source_dir    = local.tmp_dir
  dest_dir      = local.yaml_dir
  kubeseal_cert = var.kubeseal_cert
  label         = "image-registry"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${var.registry_url}' '${var.registry_namespace}' '${local.display_name}' '${local.yaml_dir}'"

    environment = {
      TMP_DIR = local.tmp_dir
      IMAGE_URL = local.image_url
      SEALED_SECRETS = yamlencode(module.seal_secrets.sealed_secrets)
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(yamlencode(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
