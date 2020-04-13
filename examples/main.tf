variable "name" {}
variable "dns_name" {}
variable "gitlab_noproxy_dns_name" {}
variable "dns_domain" {}
variable "dns_zone_id" {}
variable "ami_id" {}
variable "key_name" {}
variable "vpc_id" {}
variable "tags" { type = map(string) }
variable "gitlab_subnet_id" {}
variable "gitlab_runner_subnet_ids" { type = list(string) }
variable "gitlab_noproxy_subnet_id" {}
variable "gitlab_noproxy_runner_subnet_ids" { type = list(string) }

variable "ssm_kms_key_arn" {}


data "aws_iam_policy_document" "permission_policy" {
  statement {
    sid       = "GitabRunnerAdditionalPolicy"
    actions   = ["*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "runner_policy" {
  name_prefix = format("%s-runner-additional-policy", var.name)
  policy      = data.aws_iam_policy_document.permission_policy.json
}

module "gitlab" {
  source = "../"

  name                                      = var.name
  dns_domain                                = var.dns_domain
  dns_zone_id                               = var.dns_zone_id
  dns_name                                  = var.dns_name
  ami_id                                    = var.ami_id
  key_name                                  = var.key_name
  gitlab_runner_iam_role_policy_attachments = list(aws_iam_policy.runner_policy.arn)
  gitlab_subnet_id                          = var.gitlab_subnet_id
  gitlab_runner_subnet_ids                  = var.gitlab_runner_subnet_ids
  vpc_id                                    = var.vpc_id
  tags                                      = var.tags

  ssm_kms_key_arn = var.ssm_kms_key_arn

  http_proxy  = "http://squid-proxy.shared-services.ews.works:3128"
  https_proxy = "http://squid-proxy.shared-services.ews.works:3128"
  no_proxy    = "localhost,127.0.0.1,::1,169.254.169.254,169.254.170.2,ews.works"

}

module "gitlab_noproxy" {
  source = "../"

  name                                      = format("%s-noproxy", var.name)
  dns_domain                                = var.dns_domain
  dns_zone_id                               = var.dns_zone_id
  dns_name                                  = var.gitlab_noproxy_dns_name
  ami_id                                    = var.ami_id
  key_name                                  = var.key_name
  gitlab_runner_iam_role_policy_attachments = list(aws_iam_policy.runner_policy.arn)
  gitlab_subnet_id                          = var.gitlab_noproxy_subnet_id
  gitlab_runner_subnet_ids                  = var.gitlab_noproxy_runner_subnet_ids
  vpc_id                                    = var.vpc_id
  tags                                      = var.tags

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


output "gitlab_noproxy_url" {
  value = module.gitlab_noproxy.gitlab_url
}

output "ssm_parameter_gitlab_noproxy_root_password" {
  value = module.gitlab_noproxy.ssm_parameter_gitlab_root_password
}

output "ssm_parameter_gitlab_noproxy_runner_registration_token" {
  value = module.gitlab_noproxy.ssm_parameter_gitlab_runner_registration_token
}

