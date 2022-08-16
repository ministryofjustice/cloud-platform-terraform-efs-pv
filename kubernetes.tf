
resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "${local.name}-efs"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs.id
    directoryPerms   = 750
  }
}

resource "kubernetes_persistent_volume" "efs_vol" {
  metadata {
    name = "raz-vol"
  }
  spec {
    access_modes                     = ["ReadWriteMany"]
    volume_mode                      = "Filesystem"
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = kubernetes_storage_class.efs.metadata.name
    capacity = {
      storage = "${var.capacity}Gi"
    }
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs.id}::${aws_efs_access_point.efs_ap.id}"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "efs_claim" {
  metadata {
    name      = local.name
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.efs.metadata.name
    resources {
      requests = {
        storage = "${var.capacity}Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.efs_vol.metadata.0.name
  }
}
