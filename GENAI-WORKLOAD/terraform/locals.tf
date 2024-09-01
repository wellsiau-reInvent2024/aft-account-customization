locals {
  sso = {
    user = {
      user_name  = unsensitive(data.aws_ssm_parameter.sso_user.value)
      first_name = unsensitive(data.aws_ssm_parameter.sso_first_name.value)
      last_name  = unsensitive(data.aws_ssm_parameter.sso_last_name.value)
      email      = unsensitive(data.aws_ssm_parameter.sso_email.value)
    }
    group = {
      name = unsensitive(data.aws_ssm_parameter.sso_group_name.value)
    }
  }
}