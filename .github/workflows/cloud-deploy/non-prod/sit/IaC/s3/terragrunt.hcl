locals {
  # Load environment and project variable
  account = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  common  = read_terragrunt_config(find_in_parent_folders("common_vars.yaml"))

  master_prefix = local.common.master_prefix

  # Extract out
  aws_account_id  = local.account.locals.aws_account_id
  aws_region      = local.region.locals.aws_region
  aws_region_code = local.region.locals.aws_region_code
  environment     = local.env.locals.environment

  project_name = local.project.locals.project_name
}

terraform {
  source = "../../../../modules//terraform-aws-s3"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  name = "${local.project_name}-${local.environment}-${local.aws_region_code}-nguyenthaiduong"
  tags = {
    "region": local.region
    "environment": local.env
  }

}