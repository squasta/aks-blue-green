
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

# External endpoint green
variable "endpoint_green_name" {
  type    = string
  default = "aks-green.standemo.com"
}

# External endpoint blue
variable "endpoint_blue_name" {
  type    = string
  default = "aks-blue.standemo.com"
}






# Traffic Manager Profile
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile

resource "azurerm_traffic_manager_profile" "Terra-trafficmanagerprofile" {
  name                   = var.trafficmanagerprofile_name
  resource_group_name    = var.resource_group
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = var.trafficmanagerrelative_name
    ttl           = 15
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
}

# small timer to wait the Traffic Manager Profile to be ready
# cf. https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_traffic_manager_profile.Terra-trafficmanagerprofile]

  create_duration = "30s"
}



# Traffic Manager Endpoints
# cf. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_endpoint

resource "azurerm_traffic_manager_endpoint" "Terra-TMEndpointGreen" {
  name                = "aks-green"
  resource_group_name = var.resource_group
  profile_name        = var.trafficmanagerprofile_name
  target              = var.endpoint_green_name
  type                = "externalEndpoints"
  weight              = 3
  depends_on = [time_sleep.wait_30_seconds]
}


# Traffic Manager Endpoints
# cf. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_endpoint

resource "azurerm_traffic_manager_endpoint" "Terra-TMEndpointBlue" {
  name                = "aks-blue"
  resource_group_name = var.resource_group
  profile_name        = var.trafficmanagerprofile_name
  target              = var.endpoint_blue_name
  type                = "externalEndpoints"
  weight              = 2
  depends_on = [time_sleep.wait_30_seconds]
}
