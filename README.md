# cloud-platform-terraform-efs-pv

This terraform module will create an EFS filesystem bound to the VPC's private subnets.

It will next createa a filesystem access point using the [EFS CSI driver](https://github.com/ministryofjustice/cloud-platform-terraform-efs-csi) and a `StorageClass` in the cluster that can be used to mount the fs on multiple pods as `ReadWriteMany`.

Access security is handled via IAM, calling https://github.com/ministryofjustice/cloud-platform-terraform-irsa to create the required `ServiceAccount`.

## Usage

See the [examples/](examples/) folder.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs_sa"></a> [efs\_sa](#module\_efs\_sa) | github.com/ministryofjustice/cloud-platform-terraform-irsa | 1.0.3 |
| <a name="module_efs_security_group"></a> [efs\_security\_group](#module\_efs\_security\_group) | terraform-aws-modules/security-group/aws//modules/nfs | 4.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.efs_ap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_persistent_volume.efs_vol](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume) | resource |
| [kubernetes_persistent_volume_claim.efs_claim](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource |
| [kubernetes_storage_class.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet_ids.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of Application you are deploying | `any` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service. | `any` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | EFS doesn't really enforce any file system capacity, this is just a hint | `number` | `2` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Encrypt filesystem | `string` | `"true"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The type of environment you're deploying to. | `any` | n/a | yes |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form team-email. | `any` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | n/a | `string` | `"false"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Team slack channel to use if we need to contact your team | `any` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name of your development team | `any` | n/a | yes |
| <a name="input_transition_to_ia"></a> [transition\_to\_ia](#input\_transition\_to\_ia) | how long it takes to transition files to the IA storage class | `string` | `"AFTER_30_DAYS"` | no |
| <a name="input_transition_to_primary_storage_class"></a> [transition\_to\_primary\_storage\_class](#input\_transition\_to\_primary\_storage\_class) | transition a file from infequent access storage to primary storage | `string` | `"AFTER_1_ACCESS"` | no |
| <a name="input_uid_gid"></a> [uid\_gid](#input\_uid\_gid) | numeric ID of file owner | `number` | `1000` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | n/a |

<!--- END_TF_DOCS --->

## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidance](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |
| sqs_name |  | string | - | yes |

## Reading Material

EFS CSI upstream: https://github.com/kubernetes-sigs/aws-efs-csi-driver
EKS persistent storage HOWTO: https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/
