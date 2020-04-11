module "gitlab_ee" {
  source = "./gitlab-ee"

  name          = var.name
  dns_domain    = var.dns_domain
  dns_zone_id   = var.dns_zone_id
  dns_name      = var.dns_name
  instance_type = var.gitlab_instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
  subnet_id     = var.gitlab_subnet_id
  vpc_id        = var.vpc_id
  tags          = var.tags

  ssm_kms_key_arn = var.ssm_kms_key_arn

  http_proxy  = var.http_proxy
  https_proxy = var.https_proxy
  no_proxy    = var.no_proxy
}

module "gitlab_runner" {
  source = "./gitlab-runner"

  name          = format("%s-runner", var.name)
  instance_type = var.gitlab_runner_instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
  subnet_ids    = var.gitlab_runner_subnet_ids
  vpc_id        = var.vpc_id
  tags          = var.tags

  gitlab_addr                                    = module.gitlab_ee.gitlab_url
  ssm_kms_key_arn                                = var.ssm_kms_key_arn
  ssm_parameter_gitlab_runner_registration_token = module.gitlab_ee.ssm_parameter_gitlab_runner_registration_token

  http_proxy  = var.http_proxy
  https_proxy = var.https_proxy
  no_proxy    = var.no_proxy
}
