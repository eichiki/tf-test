// Jumpbox VM, VPN에 사용할 Public IP 생성
resource "azurerm_public_ip" "public-pip" {
  count = 2
  name = "pip-krc-pt-hklee${count.index>=9 ?"":"0"}${count.index+1}"   
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
  allocation_method = "Dynamic"
}
 
// App Service vnet 통합용 vnet
resource "azurerm_virtual_network" "virtual-network-app" {
  name = "vnet-krc-pt-app-hklee"
  address_space = ["10.10.0.0/16"]
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
}

// App Service vnet 통합용 subnet
resource "azurerm_subnet" "subnet-app" {
  name = "sent-krc-pt-app-hklee"
  resource_group_name = var.var-resource-group-name
  virtual_network_name = azurerm_virtual_network.virtual-network-app.name
  address_prefixes = ["10.10.20.0/24"]

  // App Service를 vnet 통합하려면 subnet에 delegation(위임)을 추가해야 한다
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
    }
  }
} 

resource "azurerm_subnet" "subnet-mssql" {
  name = "sent-krc-pt-mssql-hklee"
  resource_group_name = var.var-resource-group-name
  virtual_network_name = azurerm_virtual_network.virtual-network-app.name
  address_prefixes = ["10.10.21.0/24"] 

  enforce_private_link_endpoint_network_policies = true // 프라이빗 링크 제작시 네트웍 정책 true 필요
} 

// Jumpbox용 vnet
resource "azurerm_virtual_network" "virtual-network-vpn" {
  name = "vnet-krc-pt-vpn-hklee"
  address_space = ["10.11.0.0/16"]
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
}
  
// VPN용 subnet
resource "azurerm_subnet" "subnet-vpn" {
  name = "GatewaySubnet" // VPN용 subnet은 name(GatewaySubnet)이 고정되어 있음
  resource_group_name = var.var-resource-group-name
  virtual_network_name = azurerm_virtual_network.virtual-network-vpn.name
  address_prefixes = ["10.11.20.0/24"]
} 

// Jumpbox VM용 subnet
resource "azurerm_subnet" "subnet-jb" {
  name = "sent-krc-pt-jb-hklee"
  resource_group_name = var.var-resource-group-name
  virtual_network_name = azurerm_virtual_network.virtual-network-vpn.name
  address_prefixes = ["10.11.21.0/24"]
} 

// PaaS MS-SQL Private Endpoint용 vnet