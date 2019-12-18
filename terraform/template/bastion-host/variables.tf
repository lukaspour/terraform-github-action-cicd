variable "aws_region" {
  description = "AWS region to use for all resources"
  type        = string
}

variable "global_name" {
  description = "Global name of this project/account with environment"
  type        = string
}

variable "global_project" {
  description = "Global name of this project (without environment)"
  type        = string
}

variable "local_environment" {
  description = "Local name of this environment (eg, prod, stage, dev, feature1)"
  type        = string
}

variable "tags" {
  type = map(string)
}

variable "route53_zone_name" {
  description = "Route53 zone name to assign to this ALB"
  type        = string
}

variable "s3_bucket_ssh_public_keys" {
  description = "S3 bucket with SSH public keys"
  type        = string
}

variable "bucket_secrets" {
  description = "S3 bucket containing SSH private and public key for instancess behind bastion"
  type        = string
}

variable "custom_additional_user_data_script" {
  default     = ""
  description = "Path to additional user data script for bastion host (not required)"
  type        = string
}

variable "apply_changes_immediately" {
  default     = false
  description = "Apply new configuration to the bastion host right after it is published"
  type        = bool
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of IDs of public subnets"
  type        = list(string)
}
