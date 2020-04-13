variable "gitlab_ee_version" {
  description = "the gitlab runner version"
  type        = string
  default     = "12.9.2"
}

variable "gitlab_runner_version" {
  description = "the gitlab runner version"
  type        = string
  default     = "12.9.0"
}

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

variable "gitlab_runner_iam_role_policy_attachments" {
  description = "A list of iam policies attached to the gitlab runner iam role"
  type        = list(string)
  default     = []
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

variable "gitlab_runner_asg_min_size" {
  description = "The minimum size of the gitlab runner asg"
  type        = number
  default     = 1
}

variable "gitlab_runner_asg_max_size" {
  description = "The maximum size of the gitlab runner asg"
  type        = number
  default     = 1
}

variable "gitlab_runner_asg_desired_capacity" {
  description = "The number of ec2 instances that should be running"
  type        = number
  default     = 1
}

variable "ssm_kms_key_arn" {
  description = "the kms key used to decrypt ssm parameter values"
  type        = string
}

variable "http_proxy" {
  description = "the http proxy"
  type        = string
  default     = ""
}

variable "https_proxy" {
  description = "the https proxy"
  type        = string
  default     = ""
}

variable "no_proxy" {
  description = "the no proxy list"
  type        = string
  default     = ""
}
