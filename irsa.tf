data "aws_iam_policy_document" "irsa" {
  statement {
    actions = [
      "elasticfilesystem:DescribeMountTargets",
      "sts:AssumeRoleWithWebIdentity"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "irsa" {
  name        = "efs-${var.cluster_name}-${var.namespace}"
  path        = "/cloud-platform/"
  policy      = data.aws_iam_policy_document.irsa.json
  description = "Policy for EFS NFS client"
}

module "efs_sa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=1.0.3"

  eks_cluster      = var.cluster_name
  namespace        = var.namespace
  service_account  = "efs-${var.namespace}"
  role_policy_arns = [aws_iam_policy.irsa.arn]
}
