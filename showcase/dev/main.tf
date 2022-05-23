data "opentelekomcloud_identity_project_v3" "current" {}

module "cloud_tracing_service" {
  providers    = { opentelekomcloud = opentelekomcloud.top_level_project }
  source       = "iits-consulting/project-factory/opentelekomcloud//modules/cloud_tracing_service"
  version      = "4.0.0"
  bucket_name  = replace(lower("${data.opentelekomcloud_identity_project_v3.current.name}-cts"), "_", "-")
  project_name = data.opentelekomcloud_identity_project_v3.current.name
}

module "vpc" {
  source     = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version    = "4.0.0"
  name       = "${var.context}-${var.stage}-vpc"
  tags       = local.tags
  cidr_block = var.vpc_cidr
  subnets = {
    "${var.context}-${var.stage}-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
}

module "cce" {
  source  = "iits-consulting/project-factory/opentelekomcloud//modules/cce"
  version = "4.0.0"
  name    = "${var.context}-${var.stage}"

  cluster_config = {
    vpc_id = module.vpc.vpc.id
    subnet_id = values(module.vpc.subnets)[
      0
    ].id
    cluster_version   = "v1.21"
    high_availability = var.cluster_config.high_availability
    enable_scaling    = var.cluster_config.enable_scaling
  }
  node_config = {
    availability_zones = var.availability_zones
    node_count         = var.cluster_config.nodes_count
    node_flavor        = var.cluster_config.node_flavor
    node_storage_type  = var.cluster_config.node_storage_type
    node_storage_size  = var.cluster_config.node_storage_size
  }
  autoscaling_config = {
    nodes_max = var.cluster_config.nodes_max
  }
  tags = local.tags
}

module "loadbalancer" {
  source       = "iits-consulting/project-factory/opentelekomcloud//modules/loadbalancer"
  version      = "4.0.0"
  context_name = var.context
  subnet_id = module.vpc.subnets[
    "${var.context}-${var.stage}-subnet"
  ].subnet_id
  stage_name = var.stage
  bandwidth  = 500
}

module "private_dns" {
  source  = "iits-consulting/project-factory/opentelekomcloud//modules/private_dns"
  version = "4.0.0"
  domain  = "internal.${var.context}.de"
  a_records = {
    example = ["192.168.0.0"]
  }
  vpc_id = module.vpc.vpc.id
}