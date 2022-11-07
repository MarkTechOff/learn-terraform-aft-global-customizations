
# SRE Permissions on the account
data "aws_caller_identity" "current" {}

# Create an SSM parameter with a caller ID
resource "aws_ssm_parameter" "sandbox_ssm" {
    name = "/AccountID"
    type = "String"
    value = "${data.aws_caller_identity.current.account_id}"
}


# This doesn't work.
# Gives errors like:
# Error: error reading SSO Instances: AccessDeniedException: User: arn:aws:sts::044617232630:assumed-role/AWSAFTExecution/aws-go-sdk-1667828003709654196 is not authorized to perform: sso:ListInstances
# This is because Terraform is executed within the Account being provisioned (using the AWSAFTExecution role) and doesnt
# have access to SSO to assign the permission set.
#module "sre_permissions" {
#    source = "./modules/permission_set" 
#
#    account_id = "${data.aws_caller_identity.current.account_id}"
#    group_name = "AWSRoles-Fed_Account_SRE"
#    permissionset_name = "AdministratorAccess"
#}