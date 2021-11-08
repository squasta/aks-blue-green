variable "PublicIP_NATGW_name" {
    type = string
    default = "NatGateway-publicIP-Demo"
}

variable "NATGW_name" {
    type = string
    default = "NatGateway-Demo"
}



# NAT Gateway

resource "azurerm_public_ip" "Terra-PublicIP-NATGW" {
  name                = var.PublicIP_NATGW_name
  location            = azurerm_resource_group.Terra_aks_rg.location
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "Terra-NATGW" {
  name                = var.NATGW_name
  location            = azurerm_resource_group.Terra_aks_rg.location
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.Terra-NATGW.id
  public_ip_address_id = azurerm_public_ip.Terra-PublicIP-NATGW.id
}

