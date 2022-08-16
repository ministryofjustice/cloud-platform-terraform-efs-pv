
variable "cluster_name" {
}

variable "namespace" {
}

variable "application" {
  description = "Name of Application you are deploying"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
}

variable "team_name" {
  description = "The name of your development team"
}

variable "environment" {
  description = "The type of environment you're deploying to."
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
}

variable "is_production" {
  default = "false"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
}

variable "encrypted" {
  description = "Encrypt filesystem"
  default     = "true"
}

variable "transition_to_ia" {
  description = "how long it takes to transition files to the IA storage class"
  default     = "AFTER_30_DAYSS"
  validation {
    condition     = contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"], var.transition_to_ia)
    error_message = "Valid transition to IA values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, or AFTER_90_DAYS"
  }
}

variable "transition_to_primary_storage_class" {
  description = "transition a file from infequent access storage to primary storage"
  default     = "AFTER_1_ACCESS"
}

variable "uid_gid" {
  description = "numeric ID of file owner"
  default     = 1000
}
