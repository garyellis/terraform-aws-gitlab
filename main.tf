module "gitlab_ee" {
  source = "./gitlab-ee"

  name                    = var.name
  dns_domain              = var.dns_domain
  dns_zone_id             = var.dns_zone_id
  dns_name                = var.dns_name
  instance_type           = var.gitlab_instance_type
  disable_api_termination = var.gitlab_disable_api_termination
  ami_id                  = var.ami_id
  key_name                = var.key_name
  subnet_id               = var.gitlab_subnet_id
  vpc_id                  = var.vpc_id
  tags                    = var.tags

  ssm_kms_key_arn = var.ssm_kms_key_arn

  gitlab_ee_version         = var.gitlab_ee_version
  gitlab_ee_restore_enabled = var.gitlab_ee_restore_enabled
  gitlab_ee_restore_s3_file = var.gitlab_ee_restore_s3_file

  http_proxy  = var.http_proxy
  https_proxy = var.https_proxy
  no_proxy    = var.no_proxy
}

module "gitlab_runner" {
  source = "./gitlab-runner"

  name                        = format("%s-runner", var.name)
  instance_type               = var.gitlab_runner_instance_type
  ami_id                      = var.ami_id
  root_block_device           = var.gitlab_runner_root_block_device
  key_name                    = var.key_name
  iam_role_policy_attachments = var.gitlab_runner_iam_role_policy_attachments
  subnet_ids                  = var.gitlab_runner_subnet_ids
  vpc_id                      = var.vpc_id
  asg_min_size                = var.gitlab_runner_asg_min_size
  asg_max_size                = var.gitlab_runner_asg_max_size
  asg_desired_capacity        = var.gitlab_runner_asg_desired_capacity
  tags                        = var.tags

  gitlab_runner_version = var.gitlab_runner_version

  gitlab_addr                                    = module.gitlab_ee.gitlab_url
  ssm_kms_key_arn                                = var.ssm_kms_key_arn
  ssm_parameter_gitlab_runner_registration_token = module.gitlab_ee.ssm_parameter_gitlab_runner_registration_token

  http_proxy  = var.http_proxy
  https_proxy = var.https_proxy
  no_proxy    = var.no_proxy
}
