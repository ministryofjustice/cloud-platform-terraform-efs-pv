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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

No outputs.

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
