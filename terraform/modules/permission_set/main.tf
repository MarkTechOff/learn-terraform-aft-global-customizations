variable "account_id" {
    description = "account id to apply permission set"
    type = string
}

variable "group_name" {
    description = "Display name of group"
    type = string
}

variable "permissionset_name" {
    description = "Name of permission set to apply"
    type = string
}

data "aws_ssoadmin_instances" "example" {}

#find the SRE permission set
data "aws_ssoadmin_permission_set" "sre_permissions" {
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  name         = "${var.permissionset_name}"
}

#find the SRE group
data "aws_identitystore_group" "sre_group" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "${var.group_name}"
  }
}

resource "aws_ssoadmin_account_assignment" "sre_assign" {
  instance_arn       = data.aws_ssoadmin_instances.example.arns[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.sre_permissions.arn

  principal_id   = data.aws_identitystore_group.sre_group.group_id
  principal_type = "GROUP"

  target_id   = "${var.account_id}"
  target_type = "AWS_ACCOUNT"
}

output "sso_instance_arn" {
  value = tolist(data.aws_ssoadmin_instances.example.arns)[0]
}

output "identity_store_id" {
  value = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
}

output "SRE_permission_set" {
  value = data.aws_ssoadmin_permission_set.sre_permissions.arn
}

output "SRE_Group" {
  value = data.aws_identitystore_group.sre_group.group_id
}

