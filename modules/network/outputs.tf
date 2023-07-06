

// Public IP
output "output-public-pip" {
  value       = azurerm_public_ip.public-pip[*].id
  description = "azurerm_public_ip"
}
 
// App subnet id
output "output-app-subnet-id" {
  value       = azurerm_subnet.subnet-app.id
  description = "azurerm_subnet"
}

// MS-SQL subnet id
output "output-mssql-subnet-id" {
  value       = azurerm_subnet.subnet-mssql.id
  description = "azurerm_subnet"
}

// Jumpbox subnet id
output "output-jb-subnet-id" {
  value       = azurerm_subnet.subnet-jb.id
  description = "azurerm_subnet"
}

// VPN subnet id
output "output-vpn-subnet-id" {
  value       = azurerm_subnet.subnet-vpn.id
  description = "azurerm_subnet"
}