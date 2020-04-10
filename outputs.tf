output "gitlab_url" {
  value = module.gitlab_ee.gitlab_url
}

output "ssm_parameter_gitlab_root_password" {
  value = module.gitlab_ee.ssm_parameter_gitlab_root_password
}

output "ssm_parameter_gitlab_runner_registration_token" {
  value = module.gitlab_ee.ssm_parameter_gitlab_runner_registration_token
}
