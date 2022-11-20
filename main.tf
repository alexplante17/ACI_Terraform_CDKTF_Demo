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
  password = "C1sco12345"
  # cisco-aci url
  url      = "https://10.10.20.14"
  # Use insecure HTTP
  insecure = true
}

# Ressource configuration

# Tenant
resource "aci_tenant" "tenantLocalName" {
    name = "terraform_tennant"
}

# VRF
resource "aci_vrf" "vrfLocalName" {
    name = "terraform_vrf"
    tenant_dn = aci_tenant.tenantLocalName.id
}

# Bridge Domain
resource "aci_bridge_domain" "bdLocalName" {
  name = "terraform_bd_1"
  tenant_dn = aci_tenant.tenantLocalName.id
  relation_fv_rs_ctx = aci_vrf.vrfLocalName.id
}

# Subnet
resource "aci_subnet" "subnetLocalName" {
    parent_dn = aci_bridge_domain.bdLocalName.id
    ip = "10.0.0.1/24"
    scope = [ "public" ]
}

# Application Profile
resource "aci_application_profile" "apLocalName" {
  tenant_dn = aci_tenant.tenantLocalName.id
  name = "terraform_app"
}

# Web EPG
resource "aci_application_epg" "webEpgLocalName" {
  name = "terraform_epg_1"
  application_profile_dn = aci_application_profile.apLocalName.id
  relation_fv_rs_bd = aci_bridge_domain.bdLocalName.id
  pref_gr_memb = "include"
}