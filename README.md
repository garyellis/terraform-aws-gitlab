# terraform-aws-gitlab
Deploy gitlab ee server and runners together or as separately.

### gitlab-ee
The gitlab-ee module deploys gitlab ee ec2 instance, security group, s3 backups bucket, iam instance profile, dns a record, and ssm parameter store configuration to maintain gitlab root user and runner registration tokens.
The gitlab-ee application is installed by a cloud-init userdata script. The script configures the gitlab ebs data volume, installs gitlab-ee omnibus package and configures the gitlab application. The gitlab root password and runner registration tokens are fetched from ssm as part of configuring the gitlab app.


### gitlab-runner
The gitlab-runner module deploys a gitlab runner asg, launch config, security group, instance profile and ssm parameter read configuration needed to fetch the runner registration token.
The gitlab runner is installed by a cloud-init userdata script. The script installs docker, gitlab runner, and registers shell and docker executers to the gitlab ee server.


# Usage
Deploy gitlab server and runner terraform modules together.

```
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
  source = "github.com/garyellis/tf-module-gitlab"

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

```
