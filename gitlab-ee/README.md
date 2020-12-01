# terraform-aws-gitlab-ee
Deploy gitlab ee server component.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_id | The ami id | `string` | `""` | no |
| disable\_api\_termination | protect from accidental ec2 instance termination | `bool` | `false` | no |
| dns\_domain | the route53 private zone domain name | `string` | n/a | yes |
| dns\_name | the rout53 private zone dns name. (does not include the dns domain) | `string` | n/a | yes |
| dns\_zone\_id | the route53 private zone dns id. | `string` | n/a | yes |
| gitlab\_ee\_version | the gitlab runner version | `string` | `"12.9.2"` | no |
| http\_proxy | the http proxy | `string` | `""` | no |
| https\_proxy | the https proxy | `string` | `""` | no |
| iam\_role\_policy\_attachments | A list of iam policies attached to the ec2 instance role | `list(string)` | `[]` | no |
| instance\_type | the aws instance type | `string` | `"t3.xlarge"` | no |
| key\_name | assign a keypair to the ec2 instance. Overrides the default keypair name when var.key\_public\_key\_material and var.key\_name are set | `string` | `""` | no |
| name | the resources name | `string` | n/a | yes |
| no\_proxy | the no proxy list | `string` | `""` | no |
| ssm\_kms\_key\_arn | the kms key used to decrypt ssm parameter values | `string` | n/a | yes |
| subnet\_id | A list of subnet ids | `string` | n/a | yes |
| tags | provide a map of aws tags | `map(string)` | `{}` | no |
| vpc\_id | the current vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gitlab\_url | n/a |
| private\_ip | n/a |
| ssm\_parameter\_gitlab\_root\_password | n/a |
| ssm\_parameter\_gitlab\_runner\_registration\_token | n/a |
