
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "registry_server" {
  type        = string
  description = "The server/host of the image registry"
}

variable "registry_user" {
  type        = string
  description = "The username to access the image registry"
}

variable "registry_password" {
  type        = string
  description = "The password to access the image registry"
}

variable "registry_namespace" {
  type        = string
  description = "The namespace in the image registry"
}

variable "registry_url" {
  type        = string
  description = "The url to access the image registry in a browser"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "image_url" {
  type        = string
  description = "The url of the image that will be added to console link. If not provided the image will be empty"
  default     = ""
}

variable "display_name" {
  type        = string
  description = "The display name that will appear in the console link. If not provided the value will default to 'Image Registry'"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}
