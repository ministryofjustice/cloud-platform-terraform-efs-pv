provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "efs" {
  # check latest release
  # source = "github.com/ministryofjustice/cloud-platform-terraform-efs-pv?ref=1.0"
  source = "../"

  cluster_name           = var.cluster_name == "live-1" ? "live" : var.cluster_name
  namespace              = var.namespace
  application            = var.application
  business_unit          = var.business_unit
  environment            = var.environment
  infrastructure_support = var.infrastructure_support
  is_production          = var.is_production
  team_name              = var.team_name
  slack_channel          = var.slack_channel
}

resource "kubernetes_secret" "efs_id" {
  metadata {
    name      = "efs-id"
    namespace = var.namespace
  }
  data = {
    efs-id = module.efs.efs_id
  }
}
