#  Resource Group Name
variable "resource_group" {
  type    = string
  default = "RG-demostan-21"
}

# Azure Traffic ManagerProfile name
variable "trafficmanagerprofile_name" {
  type    = string
  default = "TMprofile"
}


# Azure Traffic ManagerProfile relative name 
variable "trafficmanagerrelative_name" {
  type    = string
  default = "standemo2021"
}

