data "aws_ssoadmin_permission_set" "new_permission_sets" {
  depends_on   = [module.aws-iam-identity-center]
  for_each     = local.new_permission_sets
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  name         = each.key
}

resource "aws_ssm_parameter" "new_permission_sets" {
  for_each = data.aws_ssoadmin_permission_set.new_permission_sets

  name  = "/aft/sso/permission_set/${each.value.name}"
  type  = "String"
  value = each.value.arn
}