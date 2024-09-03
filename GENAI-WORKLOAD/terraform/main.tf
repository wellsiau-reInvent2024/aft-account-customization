module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.0"
  providers = {
    aws = aws.aft_sso
  }

  existing_permission_sets = {
    SandboxAccess = {
      permission_set_name = "SandboxAccess"
    },
    CustomPermissionAccess = {
      permission_set_name = "CustomPermissionAccess"
    }
  }

  sso_groups = {
    "${local.sso.group.name}" : {
      group_name        = local.sso.group.name
      group_description = "custom group per workload account"
    }
  }

  sso_users = {
    "${local.sso.user.user_name}" : {
      group_membership = [local.sso.group.name]
      user_name        = local.sso.user.user_name
      given_name       = local.sso.user.first_name
      family_name      = local.sso.user.last_name
      email            = local.sso.user.email
    },
  }

  account_assignments = {
    "${local.sso.group.name}" : {
      principal_name  = "${local.sso.group.name}"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = split(",", nonsensitive(data.aws_ssm_parameter.ou_permission_sets.value))
      account_ids = [
        data.aws_caller_identity.current.account_id
      ]
    },
  }
}