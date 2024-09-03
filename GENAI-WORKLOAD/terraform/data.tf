data "aws_caller_identity" "current" {}

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

data "aws_ssm_parameter" "account_ou" {
  name = "/aft/account-request/custom-fields/account_ou"
}

data "aws_ssm_parameter" "ou_permission_sets" {
  provider = aws.aft_sso
  name     = "/aft/sso/permission_set/ou/${data.aws_ssm_parameter.account_ou.value}"
}