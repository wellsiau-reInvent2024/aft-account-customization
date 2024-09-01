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

module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.0"
  providers = {
    aws = aws.aft_sso
  }

  sso_groups = {
    "${data.aws_ssm_parameter.sso_group.value}" : {
      group_name        = data.aws_ssm_parameter.sso_group.value
      group_description = "custom group per workload account"
    }
  }

  sso_users = {
    "${data.aws_ssm_parameter.sso_user.value}" : {
      group_membership = [data.aws_ssm_parameter.sso_group.value]
      user_name        = data.aws_ssm_parameter.sso_user.value
      given_name       = data.aws_ssm_parameter.sso_first_name.value
      family_name      = data.aws_ssm_parameter.sso_last_name.value
      email            = data.aws_ssm_parameter.sso_email.value
    },
  }
}