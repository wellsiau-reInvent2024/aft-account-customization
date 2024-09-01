locals {
  sso = {
    user = {
      user_name  = nonsensitive(data.aws_ssm_parameter.sso_user.value)
      first_name = nonsensitive(data.aws_ssm_parameter.sso_first_name.value)
      last_name  = nonsensitive(data.aws_ssm_parameter.sso_last_name.value)
      email      = nonsensitive(data.aws_ssm_parameter.sso_email.value)
    }
    group = {
      name = nonsensitive(data.aws_ssm_parameter.sso_group.value)
    }
  }
}