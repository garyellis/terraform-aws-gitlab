output "private_ip" {
  value = join("", module.instance.aws_instance_private_ips)
}

output "gitlab_url" {
  value = format("https://%s.%s", var.dns_name, var.dns_domain)
}

output "ssm_parameter_gitlab_root_password" {
  value = {
    name = aws_ssm_parameter.gitlab_root_password.name
    arn  = aws_ssm_parameter.gitlab_root_password.arn
    cmd  = format("aws --region %s ssm get-parameters --name %s --with-decryption|jq '.Parameters[0].Value' -r", data.aws_region.current.name, aws_ssm_parameter.gitlab_root_password.name)
  }
}

output "ssm_parameter_gitlab_runner_registration_token" {
  value = {
    name = aws_ssm_parameter.gitlab_runner_registration_token.name
    arn  = aws_ssm_parameter.gitlab_runner_registration_token.arn
    cmd  = format("aws --region %s ssm get-parameters --name %s --with-decryption|jq '.Parameters[0].Value' -r", data.aws_region.current.name, aws_ssm_parameter.gitlab_runner_registration_token.name)
  }
}
