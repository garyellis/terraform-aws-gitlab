variable "name" {}
variable "dns_name" {}
variable "dns_domain" {}
variable "dns_zone_id" {}
variable "ami_id" {}
variable "key_name" {}
variable "vpc_id" {}
variable "tags" { type = map(string) }
variable "gitlab_subnet_id" {}
variable "gitlab_runner_subnet_ids" { type = list(string) }
variable "ssm_kms_key_arn" {}


module "gitlab" {
  source = "../"

  name                     = var.name
  dns_domain               = var.dns_domain
  dns_zone_id              = var.dns_zone_id
  dns_name                 = var.dns_name
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  gitlab_subnet_id         = var.gitlab_subnet_id
  gitlab_runner_subnet_ids = var.gitlab_runner_subnet_ids
  vpc_id                   = var.vpc_id
  tags                     = var.tags

  ssm_kms_key_arn = var.ssm_kms_key_arn
}

output "gitlab_url" {
  value = module.gitlab.gitlab_url
}

output "ssm_parameter_gitlab_root_password" {
  value = module.gitlab.ssm_parameter_gitlab_root_password
}

output "ssm_parameter_gitlab_runner_registration_token" {
  value = module.gitlab.ssm_parameter_gitlab_runner_registration_token
}
