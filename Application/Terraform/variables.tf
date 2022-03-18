#GLOBAL COMMON VARIABLES
variable "location" {
    type = string
    description = "The location for the resources. This will be used for all resources"
    default = "australiasoutheast"
}

variable "subscriptionid" {
    type=string
#    default = "e86103bf-c95b-4ca8-a88a-234a0d6c2bb4"
    default= "bacff720-add4-4982-b1d1-edddd7173688"
}

variable "Environment" {
    type = string
    description = "Please provide name of the environment i.e., test,uat,prod etc."

    # validation {
    #     # regex(...) fails if it cannot find a match
    #     condition     = can(regex("^timesheet-test-rg-", var.timesheet_test_rg_name))
    #     error_message = "The resource group must be valid starting with 'timesheet-test-rg-'."
    # }
}

variable "AppService_Plan_name" {
    type = string
    description = "Please provide name of the App Service Plan"
    default = "plan-cicdpoc"
}

variable "AppServiceName" {
    type = string
    description = "Please provide name of the App Service"
    default = "app-cicdpoc"
}
