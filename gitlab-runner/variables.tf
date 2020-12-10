variable "gitlab_runner_version" {
  description = "the gitlab runner version"
  type        = string
  default     = "12.9.0"
}

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

variable "root_block_device" {
  description = "the gitlab runner root block device"
  type        = list(map(string))
  default     = [{
      encrypted   = true
      volume_size = "50"
      volume_type = "gp2"
    }]
}

variable "iam_role_policy_attachments" {
  description = "A list of iam policies attached to the ec2 instance role"
  type        = list(string)
  default     = []
}

variable "asg_min_size" {
  description = "The minimum size of the gitlab runner asg"
  type        = string
}

variable "asg_max_size" {
  description = "The maximum size of the gitlab runner asg"
  type        = string
}

variable "asg_desired_capacity" {
  description = "The number of ec2 instances that should be running"
  type        = string
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
