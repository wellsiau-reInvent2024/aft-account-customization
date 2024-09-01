# data "aws_ssoadmin_permission_set" "new_setup" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
#   name         = "SandboxAccess"
# }

# resource "aws_ssm_parameter" "sso_permset_name" {
#   for_each = toset(["SandboxAccess", "CustomPermissionAccess"])

#   name  = "/aft/network/ipam/pool/${each.key}"
#   type  = "String"
#   value = module.ipam.pools_level_2[each.key].id
# }