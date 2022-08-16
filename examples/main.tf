provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "template" {
  source = "../"

  cluster_name           = "example-cluster"
  team_name              = "example-repo"
  business-unit          = "example-bu"
  application            = "example-app"
  is-production          = "false"
  namespace              = "example-ns"
  environment-name       = "example-env"
  infrastructure-support = "example-team"
}
