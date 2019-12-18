module "bastion-host" {
  source = "../template/bastion-host"

  aws_region        = local.aws_region
  global_project    = local.global_project
  local_environment = local.local_environment
  global_name       = local.global_name

  route53_zone_name = "neo-dev.test.net."

  s3_bucket_ssh_public_keys = "neo-dev-public-keys"

  bucket_secrets = "neo-dev-secrets"

  custom_additional_user_data_script = "./bin/additional_bastion.sh"

  apply_changes_immediately = true

  vpc_id = module.vpc.vpc_id

  public_subnets = module.vpc.public_subnets

  tags = {
    Project     = "neo"
    Environment = "dev"
  }
}

