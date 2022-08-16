
resource "aws_efs_file_system" "efs" {
  encrypted = var.encrypted
  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }
  lifecycle_policy {
    transition_to_primary_storage_class = var.transition_to_primary_storage_class
  }
  tags = {
    Terraform                                   = true
    Name                                        = local.name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

module "efs_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/nfs"
  version             = "4.9.0"
  name                = "${local.name}-efs"
  description         = "Security group for EFS"
  vpc_id              = data.aws_vpc.selected.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  tags = {
    Terraform                                   = true
    Name                                        = "${local.name}-efs"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_efs_mount_target" "efs" {
  count           = length(data.aws_subnet_ids.private.ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = sort(data.aws_subnet_ids.private.ids)[count.index]
  security_groups = [module.efs_security_group.security_group_id]
}

resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id
  root_directory {
    path = "/data"
    creation_info {
      owner_gid   = var.uid_gid
      owner_uid   = var.uid_gid
      permissions = 755
    }
  }
  posix_user {
    gid = var.uid_gid
    uid = var.uid_gid
  }
  tags = {
    Terraform                                   = true
    Name                                        = local.name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
