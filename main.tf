# Provider declaration
terraform {
  required_providers {
    aci = {
        source = "CiscoDevNet/aci"
    }
  }
}

# Provider configuration
provider "aci" {
  # cisco-aci user name
  username = "admin"
  # cisco-aci password
  password = "C1sc012345"
  # cisco-aci url
  url      = "https://10.10.20.14"
  # Use insecure HTTP
  insecure = true
}

# Ressource configuration
resource "aci_tenant" "vanilla" {
  name = "vanilla"
}


resource "mso_tenant" "vanilla" {
  name = "vanilla"
  display_name = "vanilla"
}