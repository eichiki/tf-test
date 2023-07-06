/////////////////////////////////////////////////////////////////////////////////
// UlbaHoldings CI/CD
// ASP 시연용
/////////////////////////////////////////////////////////////////////////////////

terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>3.1"
        }
    }
}  
 
provider "azurerm" {
    // ASP 진행을 위한 구독정보
    subscription_id = "98a535e1-7877-4380-829f-6ead0dfe026b"
    features {} 
} 

module "rg" {
    source = "./modules/rg"

    # module 사용시 module내 변수에 value 전달
    # module내 변수명 = var.변수명
    in-resource-group-name = var.resource-group-name
    in-resource-group-location = var.resource-group-location
}

module "vnet" {
    source = "./modules/vnet"

    # module 사용시 module내 변수에 value 전달
    # module내 변수명 = var.변수명
    in-resource-group-name = var.resource-group-name
    in-resource-group-location = var.resource-group-location
}

module "app" {
    source = "./modules/app"

    # module 사용시 module내 변수에 value 전달
    # module내 변수명 = var.변수명
    in-resource-group-name = var.resource-group-name
    in-resource-group-location = var.resource-group-location
}

module "vm" {
    source = "./modules/vm"

    in-resource-group-name = var.resource-group-name
    in-resource-group-location = var.resource-group-location
 
    in-subnet-id = "${module.vnet.output-app-subnet-id}"
} 

module "vmss" {
    source = "./modules/vmss"

    in-resource-group-name = var.resource-group-name
    in-resource-group-location = var.resource-group-location
 
    in-subnet-id = "${module.vnet.output-app-subnet-id}"
} 

