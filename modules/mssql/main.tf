// Storage Account 생성
resource "azurerm_storage_account" "storage-account" {
  name = "storagehklee"
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "mssql-server" {
  name = "sql-krc-pt-server-hklee"
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
  version = "12.0"
  administrator_login = "jackadmin"
  administrator_login_password = "Password!@#$"

  public_network_access_enabled = true
}

resource "azurerm_mssql_database" "mssql-database" {
  name           = "hkleeDB"
  server_id      = azurerm_mssql_server.mssql-server.id
  collation      = "Korean_Wansung_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true 
} 

/*
############################################################################################
// DB Private Endpoint
############################################################################################
resource "azurerm_private_endpoint" "private-endpoint" {
  name                = "mssql_endpoint" 
  location            = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
  subnet_id           = var.var-mssql-subnet-id

  private_service_connection {
    name                           = "mssqlprivatelink"     
    is_manual_connection           = "true"
    request_message                = "Auto-approved"
    private_connection_resource_id = azurerm_mssql_server.mssql-server.id
    subresource_names              = ["sqlServer"] // 정해진 리소스명을 변경하면 안됨
  }
}
*/