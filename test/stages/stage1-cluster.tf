module "dev_cluster" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-login.git"

  server_url = var.server_url
  login_user = var.cluster_username
  login_password = var.cluster_password
  login_token = ""
  ca_cert = var.cluster_ca_cert
}

resource null_resource output_kubeconfig {
  provisioner "local-exec" {
    command = "echo '${module.dev_cluster.platform.kubeconfig}' > .kubeconfig"
  }
}

/*resource "null_resource" "IBMcloud-login" {
    provisioner "local-exec" {
    command =  "ibmcloud login  --apikey '${var.ibmcloud_api_key}' -a cloud.ibm.com -r us-south"
    environment = {
      BIN_DIR = module.setup_clis.bin_dir      
    }
    }
}*/

  
