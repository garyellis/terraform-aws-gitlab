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

## Requirements


## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_id | The ami id | `string` | n/a | yes |
| dns\_domain | The route53 private zone domain name | `string` | n/a | yes |
| dns\_name | The rout53 private zone dns name. (does not include the dns domain) | `string` | n/a | yes |
| dns\_zone\_id | The route53 private zone dns id. | `string` | n/a | yes |
| gitlab\_disable\_api\_termination | Protect the gitlab server from accidental ec2 instance termination | `bool` | `false` | no |
| gitlab\_ee\_version | the gitlab runner version | `string` | `"12.9.2"` | no |
| gitlab\_instance\_type | The gitlab server ec2 instance type | `string` | `"t3.xlarge"` | no |
| gitlab\_runner\_asg\_desired\_capacity | The number of ec2 instances that should be running | `number` | `1` | no |
| gitlab\_runner\_asg\_max\_size | The maximum size of the gitlab runner asg | `number` | `1` | no |
| gitlab\_runner\_asg\_min\_size | The minimum size of the gitlab runner asg | `number` | `1` | no |
| gitlab\_runner\_iam\_role\_policy\_attachments | A list of iam policies attached to the gitlab runner iam role | `list(string)` | `[]` | no |
| gitlab\_runner\_instance\_type | The gitlab runner ec2 instance type | `string` | `"t3.medium"` | no |
| gitlab\_runner\_root\_block\_device | the gitlab runner root block device setting | `list(map(string))` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": "50",<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| gitlab\_runner\_subnet\_ids | A list of subnet ids associated to the gitlab runner asg | `list(string)` | n/a | yes |
| gitlab\_runner\_version | the gitlab runner version | `string` | `"12.9.0"` | no |
| gitlab\_subnet\_id | The gitlab server subnet id | `string` | n/a | yes |
| http\_proxy | the http proxy | `string` | `""` | no |
| https\_proxy | the https proxy | `string` | `""` | no |
| key\_name | The ec2 instances keypair | `string` | `""` | no |
| name | A a name prefix applied to all resources | `string` | n/a | yes |
| no\_proxy | the no proxy list | `string` | `""` | no |
| ssm\_kms\_key\_arn | the kms key used to decrypt ssm parameter values | `string` | n/a | yes |
| tags | A map of tags applied to all taggable resources | `map(string)` | `{}` | no |
| vpc\_id | the target vpc | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gitlab\_url | n/a |
| ssm\_parameter\_gitlab\_root\_password | n/a |
| ssm\_parameter\_gitlab\_runner\_registration\_token | n/a |
