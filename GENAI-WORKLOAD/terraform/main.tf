module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.0"
  providers = {
    aws = aws.aft_sso
  }

  sso_groups = {
    "${local.sso.group.name}" : {
      group_name        = local.sso.group.name
      group_description = "custom group per workload account"
    }
  }

  sso_users = {
    "${local.sso.user.user_name}" : {
      group_membership = [local.sso_group.name]
      user_name        = local.sso.user.user_name
      given_name       = local.sso.user.given_name
      family_name      = local.sso.user.family_name
      email            = local.sso.user.email
    },
  }
}