variable "name" {
  description = "A a name prefix applied to all resources"
  type        = string
}

variable "dns_name" {
  description = "The rout53 private zone dns name. (does not include the dns domain)"
  type        = string
}

variable "dns_domain" {
  description = "The route53 private zone domain name"
  type        = string
}

variable "dns_zone_id" {
  description = "The route53 private zone dns id."
  type        = string
}

variable "ami_id" {
  description = "The ami id"
  type        = string
}

variable "key_name" {
  description = "The ec2 instances keypair"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "the target vpc"
  type        = string
}

variable "tags" {
  description = "A map of tags applied to all taggable resources"
  type        = map(string)
  default     = {}
}

variable "gitlab_instance_type" {
  description = "The gitlab server ec2 instance type"
  type        = string
  default     = "t3.xlarge"
}

variable "gitlab_subnet_id" {
  description = "The gitlab server subnet id"
  type        = string
}

variable "gitlab_runner_subnet_ids" {
  description = "A list of subnet ids associated to the gitlab runner asg"
  type        = list(string)
}


variable "gitlab_runner_instance_type" {
  description = "The gitlab runner ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssm_kms_key_arn" {
  description = "the kms key used to decrypt ssm parameter values"
  type        = string
}
