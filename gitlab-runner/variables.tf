variable "name" {
  description = "the resources name"
  type        = string
}

variable "ami_id" {
  description = "The ami id"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of subnet ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "the current vpc id"
  type        = string
}

variable "instance_type" {
  description = "the aws instance type"
  type        = string
  default     = "t2.medium"
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

variable "gitlab_addr" {
  description = "the target gitlab server address"
  type        = string
}

variable "ssm_parameter_gitlab_runner_registration_token" {
  description = "the gitlab runner registration token arn and name"
  type        = map(string)
}

variable "ssm_kms_key_arn" {
  description = "the kms key needed to decrypt ssm parameter values"
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
