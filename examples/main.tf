provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "template" {
  source = "../"

  cluster_name           = "example-cluster"
  team_name              = "example-repo"
  business_unit          = "example-bu"
  application            = "example-app"
  is_production          = "false"
  namespace              = "example-ns"
  environment            = "example-env"
  infrastructure_support = "example-team"
  slack_channel          = "#example-channel"
}
