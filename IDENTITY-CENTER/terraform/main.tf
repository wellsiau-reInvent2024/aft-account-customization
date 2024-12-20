module "aws-iam-identity-center" {
  for_each = local.new_permission_sets
  source   = "aws-ia/iam-identity-center/aws"
  version  = "1.0.0"

  permission_sets = {
    "${each.key}" = {
      description          = each.value.description
      session_duration     = "PT8H",
      aws_managed_policies = each.value.aws_managed_policies,
      tags                 = { ManagedBy = "AFT" }
    }
  }
}