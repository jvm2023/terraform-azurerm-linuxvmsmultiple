output "publicipsofvms" {
    value = azurerm_public_ip.example[*].ip_address
  
}