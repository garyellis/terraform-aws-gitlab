data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  # consider variable inputs for ssm parameter names for loose coupling to gitlab-runner module

  ssm_parameter_path                      = format("/gitlab/%s", var.name)
  ssm_parameter_root_password             = format("%s/%s", local.ssm_parameter_path, "root/password")
  ssm_parameter_runner_registration_token = format("%s/%s", local.ssm_parameter_path, "runner/registration/token")

  secretsmanager_secret_gitlab_secrets_json = format("gitlab/%s/gitlab-secrets.json", var.name)

  secretsmanager_secret_backup_gitlab_secrets_arn = format(
    "arn:aws:secretsmanager:%s:%s:secret:%s",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    format("%s*", local.secretsmanager_secret_gitlab_secrets_json))
}

#### ssm parameters config
resource "random_password" "gitlab_root_password" {
  length      = 26
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "random_password" "gitlab_runner_registration_token" {
  length      = 32
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}


resource "aws_ssm_parameter" "gitlab_root_password" {
  description = "The gitlab root password"
  name        = local.ssm_parameter_root_password
  type        = "SecureString"
  value       = random_password.gitlab_root_password.result
  tags        = {}
}

resource "aws_ssm_parameter" "gitlab_runner_registration_token" {
  description = "The gitlab runner registration token"
  name        = local.ssm_parameter_runner_registration_token
  type        = "SecureString"
  value       = random_password.gitlab_runner_registration_token.result
  tags        = {}
}

module "backups_s3_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v1.9.0"

  bucket_prefix = format("%s-backups", var.name)
  acl           = "private"
  force_destroy = true
  logging       = {}
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = var.tags
}


# https://docs.gitlab.com/ee/raketasks/backup_restore.html#other-s3-providers
data "aws_iam_policy_document" "gitlab_ee" {
  statement {
    sid    = "Stmt1412062044000"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      format("%s/*", module.backups_s3_bucket.this_s3_bucket_arn)
    ]
  }

  statement {
    sid    = "Stmt1412062097000"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Stmt1412062128000"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      module.backups_s3_bucket.this_s3_bucket_arn
    ]
  }

  statement {
    sid    = "SSMGetParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:PutParameter"
    ]
    resources = list(
      aws_ssm_parameter.gitlab_root_password.arn,
      aws_ssm_parameter.gitlab_runner_registration_token.arn,
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

  statement {
    sid    = "SecretsManagerList"
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SecretsManagerReadWrite"
    effect = "Allow"
    actions = [
      "secretsmanager:Create*",
      "secretsmanager:Put*",
      "secretsmanager:Rotate*",
      "secretsmanager:Update*",
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      local.secretsmanager_secret_backup_gitlab_secrets_arn
    ]
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

resource "aws_iam_policy" "gitlab_ee" {
  name_prefix = var.name
  policy      = data.aws_iam_policy_document.gitlab_ee.json
}

resource "aws_iam_role_policy_attachment" "gitlab_ee" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.gitlab_ee.arn
}

resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  description        = "gitlab ee iam role"
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
    gitlab_ee_version                              = var.gitlab_ee_version
    gitlab_ee_restore_enabled                      = var.gitlab_ee_restore_enabled
    gitlab_ee_restore_s3_file                      = var.gitlab_ee_restore_s3_file
    secretsmanager_secret_gitlab_secrets_json      = local.secretsmanager_secret_gitlab_secrets_json
    dns_fqdn                                       = format("%s.%s", var.dns_name, var.dns_domain)
    backups_s3_bucket                              = module.backups_s3_bucket.this_s3_bucket_id
    backups_s3_bucket_region                       = data.aws_region.current.name
    ssm_region                                     = data.aws_region.current.name
    ssm_parameter_root_password                    = aws_ssm_parameter.gitlab_root_password.name
    ssm_parameter_runner_registration_token        = aws_ssm_parameter.gitlab_runner_registration_token.name
    secondary_block_device                         = "/dev/nvme1n1"
  })
}

module "userdata" {
  source = "github.com/garyellis/tf_module_cloud_init?ref=v0.2.3"

  base64_encode          = false
  gzip                   = false
  install_docker         = true
  install_docker_compose = false
  extra_user_data_script = local.userdata_script

  install_http_proxy_env = var.http_proxy == "" ? false : true
  http_proxy             = var.http_proxy
  https_proxy            = var.https_proxy
  no_proxy               = var.no_proxy
}


module "instance" {
  source = "github.com/garyellis/tf_module_aws_instance?ref=v1.3.2"

  count_instances             = 1
  name                        = var.name
  ami_id                      = var.ami_id
  iam_instance_profile        = aws_iam_instance_profile.instance.name
  user_data                   = module.userdata.cloudinit_userdata
  instance_type               = var.instance_type
  disable_api_termination     = var.disable_api_termination
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_group_attachments  = list(module.sg.security_group_id)
  subnet_ids                  = list(var.subnet_id)
  tags                        = var.tags

  root_block_device = [{
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 40
    encrypted             = true
    snapshot_id           = null
    },
  ]

  ebs_block_device = [{
    delete_on_termination = true
    device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    volume_size           = 500
    encrypted             = true
    snapshot_id           = null
    },
  ]

  instance_auto_recovery_enabled = true
}

module "dns" {
  source = "github.com/garyellis/tf_module_aws_route53_zone"

  name            = var.dns_domain
  zone_id         = var.dns_zone_id
  a_records_count = 1
  a_records       = [{ name = var.dns_name, record = join("", module.instance.aws_instance_private_ips) }]
  vpc_id          = var.vpc_id
}
