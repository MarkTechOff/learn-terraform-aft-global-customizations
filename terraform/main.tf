
# SRE Permissions on the account
data "aws_caller_identity" "current" {}

module "sre_permissions" {
    source = "./modules/permission_set" 

    account_id = "${data.aws_caller_identity.current.account_id}"
    group_name = "AWSRoles-Fed_Account_SRE"
    permissionset_name = "AdministratorAccess"
}