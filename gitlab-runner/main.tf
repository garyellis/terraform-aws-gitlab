data "aws_region" "current" {}

#### iam instance profile
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "SSMGetParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:PutParameter"
    ]
    resources = list(
      lookup(var.ssm_parameter_gitlab_runner_registration_token, "arn")
    )
  }

  statement {
    sid    = "SSMDescribeParameters"
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SSMDecryptParameter"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    resources = list(
      var.ssm_kms_key_arn
    )
  }
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name_prefix = var.name
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  description        = "gitlab runner iam role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "instance" {
  name_prefix = var.name
  role        = aws_iam_role.instance.name
}


module "sg" {
  source = "github.com/garyellis/tf_module_aws_security_group"

  description                   = format("%s security group", var.name)
  egress_cidr_rules             = []
  egress_security_group_rules   = []
  ingress_cidr_rules            = []
  ingress_security_group_rules  = []
  name                          = var.name
  tags                          = var.tags
  toggle_allow_all_egress       = true
  toggle_allow_all_ingress      = true
  toggle_self_allow_all_egress  = true
  toggle_self_allow_all_ingress = true
  vpc_id                        = var.vpc_id
}

locals {
  userdata_script = templatefile("${path.module}/userdata.tmpl", {
    gitlab_addr                                    = var.gitlab_addr
    ssm_region                                     = data.aws_region.current.name
    ssm_parameter_gitlab_runner_registration_token = lookup(var.ssm_parameter_gitlab_runner_registration_token, "name")

    http_proxy  = var.http_proxy
    https_proxy = var.https_proxy
    no_proxy    = var.no_proxy
  })
}

module "userdata" {
  source = "github.com/garyellis/tf_module_cloud_init"

  base64_encode          = false
  gzip                   = false
  install_docker         = true
  install_docker_compose = true
  extra_user_data_script = local.userdata_script
}

module "instance" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = var.name

  # launch config
  lc_name              = var.name
  user_data            = module.userdata.cloudinit_userdata
  iam_instance_profile = aws_iam_instance_profile.instance.name
  key_name             = var.key_name
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = list(module.sg.security_group_id)
  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # asg
  asg_name                     = var.name
  recreate_asg_when_lc_changes = true
  vpc_zone_identifier          = var.subnet_ids
  health_check_type            = "EC2"
  min_size                     = 0
  max_size                     = 3
  desired_capacity             = 3
  wait_for_capacity_timeout    = 0
  tags_as_map                  = var.tags
}
