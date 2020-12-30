variable "gitlab_ee_version" {
  description = "the gitlab runner version"
  type        = string
  default     = "12.9.2"
}

variable "gitlab_ee_restore_enabled" {
  description = "The gitlab runner version"
  type        = bool
  default     = false
}

variable "gitlab_ee_restore_s3_file" {
  description = "The gitlab backup s3 path. i.e. s3://my-bucket-name/daily/my-backup.tar "
  type        = string
  default     = ""
}

variable "name" {
  description = "the resources name"
  type        = string
}

variable "dns_name" {
  description = "the rout53 private zone dns name. (does not include the dns domain)"
  type        = string
}

variable "dns_domain" {
  description = "the route53 private zone domain name"
  type        = string
}

variable "dns_zone_id" {
  description = "the route53 private zone dns id."
  type        = string
}

variable "ami_id" {
  description = "The ami id"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "A list of subnet ids"
  type        = string
}

variable "vpc_id" {
  description = "the current vpc id"
  type        = string
}

variable "instance_type" {
  description = "the aws instance type"
  type        = string
  default     = "t3a.xlarge"
}

variable "disable_api_termination" {
  description = "protect from accidental ec2 instance termination"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "assign a keypair to the ec2 instance. Overrides the default keypair name when var.key_public_key_material and var.key_name are set"
  type        = string
  default     = ""
}

variable "iam_role_policy_attachments" {
  description = "A list of iam policies attached to the ec2 instance role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "provide a map of aws tags"
  type        = map(string)
  default     = {}
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
