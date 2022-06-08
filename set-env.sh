# Either your ACCESS_KEY and SECRET_KEY or from a serviceaccount

#### OTC CREDENTIALS #####
export OS_DOMAIN_NAME=$(vault kv get --field OS_DOMAIN_NAME secret/otc_credentials/openinfra)
export OS_ACCESS_KEY=$(vault kv get --field OS_ACCESS_KEY secret/otc_credentials/openinfra)
export OS_SECRET_KEY=$(vault kv get --field OS_SECRET_KEY secret/otc_credentials/openinfra)
export AWS_ACCESS_KEY_ID=$OS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$OS_SECRET_KEY
export TF_VAR_region="eu-de"

##### PROJECT CONFIGURATION #####
#Current Context you are working on can be customer name or cloud name etc.
export TF_VAR_context="openinfra"
# Current Stage you are working on for example dev,qa, prod etc.
export TF_VAR_stage="dev"
export OS_PROJECT_NAME="eu-de_openinfra"

# ArgoCD/K8s config
export TF_VAR_registry_credentials_dockerconfig_username=$(vault kv get --field DOCKERCONFIG_USERNAME secret/otc_credentials/openinfra)
export TF_VAR_registry_credentials_dockerconfig_password=$(vault kv get --field DOCKERCONFIG_PASSWORD secret/otc_credentials/openinfra)
export TF_VAR_argocd_git_access_token=$(vault kv get --field ARGOCD_GIT_ACCESS_TOKEN secret/otc_credentials/openinfra)

#### TERRAFORM LOCAL PLUGIN CACHING #####
mkdir -p ${HOME}/Terraform/plugins
export TF_PLUGIN_CACHE_DIR=${HOME}/Terraform/plugins