data "aws_ssm_parameter" "sso_user" {
  name = "/aft/account-request/custom-fields/sso_user"
}

data "aws_ssm_parameter" "sso_first_name" {
  name = "/aft/account-request/custom-fields/sso_first_name"
}

data "aws_ssm_parameter" "sso_last_name" {
  name = "/aft/account-request/custom-fields/sso_last_name"
}

data "aws_ssm_parameter" "sso_email" {
  name = "/aft/account-request/custom-fields/sso_email"
}

data "aws_ssm_parameter" "sso_group" {
  name = "/aft/account-request/custom-fields/sso_group"
}