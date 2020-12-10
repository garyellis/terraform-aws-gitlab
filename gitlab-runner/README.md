# terraform-aws-gitlab-runner
Deploy the gitlab runner component.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_id | The ami id | `string` | `""` | no |
| asg\_desired\_capacity | The number of ec2 instances that should be running | `string` | n/a | yes |
| asg\_max\_size | The maximum size of the gitlab runner asg | `string` | n/a | yes |
| asg\_min\_size | The minimum size of the gitlab runner asg | `string` | n/a | yes |
| gitlab\_addr | the target gitlab server address | `string` | n/a | yes |
| gitlab\_runner\_version | the gitlab runner version | `string` | `"12.9.0"` | no |
| http\_proxy | the http proxy | `string` | `""` | no |
| https\_proxy | the https proxy | `string` | `""` | no |
| iam\_role\_policy\_attachments | A list of iam policies attached to the ec2 instance role | `list(string)` | `[]` | no |
| instance\_type | the aws instance type | `string` | `"t2.medium"` | no |
| key\_name | assign a keypair to the ec2 instance. Overrides the default keypair name when var.key\_public\_key\_material and var.key\_name are set | `string` | `""` | no |
| name | the resources name | `string` | n/a | yes |
| no\_proxy | the no proxy list | `string` | `""` | no |
| root\_block\_device | the gitlab runner root block device | `list(map(string))` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": "50",<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| ssm\_kms\_key\_arn | the kms key needed to decrypt ssm parameter values | `string` | n/a | yes |
| ssm\_parameter\_gitlab\_runner\_registration\_token | the gitlab runner registration token arn and name | `map(string)` | n/a | yes |
| subnet\_ids | A list of subnet ids | `list(string)` | n/a | yes |
| tags | provide a map of aws tags | `map(string)` | `{}` | no |
| vpc\_id | the current vpc id | `string` | n/a | yes |

## Outputs

No output.
