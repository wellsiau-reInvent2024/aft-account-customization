locals {
  new_permission_sets = {
    SandboxAccess = {
      description = "AWS power user access permissions"
      aws_managed_policies = [
        data.aws_iam_policy.poweruser_managed_policy.arn
      ]
    }
    CustomPermissionAccess = {
      description = "Custom permissions for genai workload"
      aws_managed_policies = [
        data.aws_iam_policy.bedrock_full_access_managed_policy.arn,
        data.aws_iam_policy.ec2_readonly_managed_policy.arn
      ]
    }
  }
}