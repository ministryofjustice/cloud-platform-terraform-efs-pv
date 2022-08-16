resource "kubernetes_persistent_volume" "raz_vol" {
  metadata {
    name = "raz-vol"
  }
  spec {
    access_modes                     = ["ReadWriteMany"]
    volume_mode                      = "Filesystem"
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "raz-efs"
    capacity = {
      storage = "2Gi"
    }
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs.id}::${aws_efs_access_point.efs_ap.id}"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "raz_claim" {
  metadata {
    name      = "raz-claim"
    namespace = "raz-test-not-one"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "raz-efs"
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.raz_vol.metadata.0.name
  }
}
