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
  default     = "t3.xlarge"
}

variable "key_name" {
  description = "assign a keypair to the ec2 instance. Overrides the default keypair name when var.key_public_key_material and var.key_name are set"
  type        = string
  default     = ""
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
