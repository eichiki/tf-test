resource "azurerm_virtual_machine_scale_set" "IaaS-vmss" {
    name                 = "IaaS-vmss"
    location             = var.var-resource-group-location
    resource_group_name  = var.var-resource-group-name
    upgrade_policy_mode  = "Manual"
    
    sku {
        name    = "Standard_D2_v3"
        tier    = "Standard"
        capacity= 10
    
        storage_profile_image_reference {
            publisher     = "Canonical"
            offer         = "UbuntuServer"
            sku           = "18.04-LTS"
            version       = "latest"
        }
        
        storage_profile_os_disk {
            name              = ""
            caching           = "ReadWrite"
            create_option     = "FromImage"
            managed_disk_type = "Standard_LRS"
        }

        storage_profile_os_disk {
            name              = ""
            caching           = "ReadWrite"
            create_option     = "FromImage"
            managed_disk_type = "Standard_LRS"
        }
        
        storage_profile_data_disk {
            lun           = 0
            caching       = "ReadWrite"
            create_option = "Empty"
            disk_size_gb  = 10
        }    
    
        os_profile {
            computer_name_prefix = "IaaS-vmss"
            admin_username = "azureadmin"
            
            // VM 에 접속할 계정
            custom_data = file("web.sh")
        }
    
        os_profile_linux_config {
            disable_password_authentication = true
 
            ssh_keys {
                path = "/home/azureadmin/.ssh/authorized_keys"

                // pwd 실행 후 경로설정 ex) /home/azureadmin 등 , os_profile 계정(myadmin)과 동일해야함
                key_data = file("~/.ssh/id_rsa.pub") // VMSS.tf 생성전에 터미널에서 $ ssh-keygen 으로 생성 (엔터 3번)
            }
        }  

        network_profile {
            name         = "networkprofile"
            primary     = true    

            ip_configuration {
                name        = "TestIPConfiguration"
                primary     = true
                subnet_id   = azurerm_subnet.IaaS-subnet1.id
                load_balancer_backend_address_pool_ids     = [azurerm_lb_backend_address_pool.IaaS-bepool.id]
                load_balancer_inbound_nat_rules_ids        = [azurerm_lb_nat_pool.IaaS-lbnatpool.id]
            }   

            network_security_group_id = azurerm_network_security_group.iaas-nsg.id
        }        
        tags = {
            environment = "사용자 설정"
        }
    }
}