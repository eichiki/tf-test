// App Service Plan 생성
resource "azurerm_app_service_plan" "app-service-plan" {
  name = "asp-krc-pt-hklee"
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name

  sku {
    tier = "Premiumv2"
    size = "P1v2"
  }
} 

// App Service 생성
resource "azurerm_app_service" "app-service" {
  name = "hklee"
  location = var.var-resource-group-location
  resource_group_name = var.var-resource-group-name
  app_service_plan_id = azurerm_app_service_plan.app-service-plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    //scm_type = "LocalGit"
    default_documents = ["default.aspx", "default.html"] // App Service Default 문서를 배열로 지정한다
  }
}

// App Service vnet 통합
resource "azurerm_app_service_virtual_network_swift_connection" "app-service-vnet-swift-connection" {
  app_service_id  = azurerm_app_service.app-service.id
  subnet_id       = var.var-app-subnet-id
}