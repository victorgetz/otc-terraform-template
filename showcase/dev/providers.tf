provider "opentelekomcloud" {
  auth_url = "https://iam.${var.region}.otc.t-systems.com/v3"
}

provider "opentelekomcloud" {
  auth_url    = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name = var.region
  alias       = "top_level_project"
}


provider "kubernetes" {
  host                   = module.cce.cluster_credentials.kubectl_external_server
  client_certificate     = base64decode(module.cce.cluster_credentials.client_certificate_data)
  client_key             = base64decode(module.cce.cluster_credentials.client_key_data)
  cluster_ca_certificate = base64decode(module.cce.cluster_credentials.cluster_certificate_authority_data)
}

provider "helm" {
  kubernetes {
    host                   = module.cce.cluster_credentials.kubectl_external_server
    client_certificate     = base64decode(module.cce.cluster_credentials.client_certificate_data)
    client_key             = base64decode(module.cce.cluster_credentials.client_key_data)
    cluster_ca_certificate = base64decode(module.cce.cluster_credentials.cluster_certificate_authority_data)
  }
}
