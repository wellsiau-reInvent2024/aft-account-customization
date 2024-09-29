data "aws_ssoadmin_instances" "current" {}

data "aws_ssoadmin_permission_set" "new_permission_sets" {
  depends_on   = [module.aws-iam-identity-center]
  for_each     = local.new_permission_sets
  instance_arn = tolist(data.aws_ssoadmin_instances.current.arns)[0]
  name         = each.key
}

### All permission sets 
resource "aws_ssm_parameter" "new_permission_sets" {
  for_each = data.aws_ssoadmin_permission_set.new_permission_sets

  name  = "/aft/sso/permission_set/${each.value.name}"
  type  = "String"
  value = each.value.arn
}

### Set permission sets per OU
resource "aws_ssm_parameter" "custom_ou_permission_sets" {
  name  = "/aft/sso/permission_set/ou/Custom"
  type  = "String"
  value = "SandboxAccess,CustomPermissionAccess"
}