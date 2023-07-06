// NIC 제작(VM에서 사용할 nic 미리 만듬)
resource "azurerm_network_interface" "network-interface" {     
    name = "nic-krc-pt-jp-hklee"
    location = var.var-resource-group-location
    resource_group_name = var.var-resource-group-name

    ip_configuration {
        name = "ip_config-krc-pt-jp-hklee"
        subnet_id = var.var-jp-subnet-id
        private_ip_address_allocation = "Static" // Static, dynamic
        private_ip_address = "10.11.21.101"
        //private_ip_address = var.var_vm_ip_arr[count.index]

        public_ip_address_id = var.var-jp-public-ip
    }
}
  
// Virtual Machine 생성 - Windows 
resource "azurerm_windows_virtual_machine" "virtual-machine" {     
    name = "jumpboxvm"
    location = var.var-resource-group-location
    resource_group_name = var.var-resource-group-name     
    
    size = "Standard_F2"
    admin_username = "jackadmin"
    admin_password = "Password!@#$"

    network_interface_ids = [
        azurerm_network_interface.network-interface.id,
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    } 
}