
resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "${local.name}-efs"
    labels = {
      "velero.io/exclude-from-backup" = "true"
    }
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs.id
    directoryPerms   = 750
  }
  depends_on = [aws_efs_mount_target.efs]
}

resource "kubernetes_persistent_volume" "efs_vol" {
  metadata {
    name = "${local.name}-efs"
    labels = {
      "velero.io/exclude-from-backup" = "true"
    }
  }
  spec {
    access_modes                     = ["ReadWriteMany"]
    volume_mode                      = "Filesystem"
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "${local.name}-efs"
    capacity = {
      storage = "${var.capacity}Gi"
    }
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs.id}::${aws_efs_access_point.efs_ap.id}"
        volume_attributes = {
          podIAMAuthorization = true
        }
      }
    }
  }
  depends_on = [kubernetes_storage_class.efs]
}

resource "kubernetes_persistent_volume_claim" "efs_claim" {
  metadata {
    name      = local.name
    namespace = var.namespace
    labels = {
      "velero.io/exclude-from-backup" = "true"
    }
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "${local.name}-efs"
    resources {
      requests = {
        storage = "${var.capacity}Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.efs_vol.metadata.0.name
  }
  depends_on = [kubernetes_persistent_volume.efs_vol]
}
