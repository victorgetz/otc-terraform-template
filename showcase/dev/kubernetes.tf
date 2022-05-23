#locals {
#  dockerconfigjsonbase64 = base64encode(jsonencode({
#    auths = {
#      "https://index.docker.io/v1/" = {
#        username = var.registry_credentials_dockerconfig_username
#        password = var.registry_credentials_dockerconfig_password
#        auth     = base64encode("${var.registry_credentials_dockerconfig_username}:${var.registry_credentials_dockerconfig_password}")
#      }
#    }
#  }))
#}
#
#module "argocd" {
#  source  = "iits-consulting/bootstrap/argocd"
#  version = "1.0.0"
#
#  ## Common CRD collection Configuration, see https://github.com/iits-consulting/crds-chart
#  custom_resource_definitions_enabled = true
#
#  ### Registry Credentials Configuration for auto inject docker pull secrets, see https://github.com/iits-consulting/registry-creds-chart
#  registry_credentials_enabled      = true
#  registry_credentials_dockerconfig = local.dockerconfigjsonbase64
#
#  ### ArgoCD Configuration
#  argocd_namespace                 = "argocd"
#  argocd_project_name              = "infrastructure-charts"
#  argocd_git_access_token_username = "ARGO_CD"
#  argocd_git_access_token          = var.argocd_git_access_token
#  argocd_project_source_repo_url   = "https://github.com/iits-consulting/otc-infrastructure-charts-template.git"
#  argocd_project_source_path       = "stages/${var.stage}/infrastructure-charts"
#  argocd_application_values = {
#    global = {
#      stage = var.stage
#    }
#    traefik = {
#      terraformValues = [
#        {
#          name  = "traefik.service.annotations.kubernetes\\.io\\/elb\\.id"
#          value = module.loadbalancer.elb_id
#        }
#      ]
#    }
#  }
#}
