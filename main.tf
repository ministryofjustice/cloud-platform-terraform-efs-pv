data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.cluster_name == "live" ? "live-1" : var.cluster_name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Private"
  }
}

locals {
  name = "${var.cluster_name}-${var.namespace}"
}
