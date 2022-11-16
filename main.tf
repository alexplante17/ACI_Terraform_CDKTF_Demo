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
    name = "vanilla"
}

# VRF
resource "aci_vrf" "vrfLocalName" {
    name = "global_vrf"
    tenant_dn = aci_tenant.tenantLocalName.id
}

# Bridge Domain
resource "aci_bridge_domain" "bdLocalName" {
  name = "global_bd"
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
  name = "3tier_ap"
}

# Web EPG
resource "aci_application_epg" "webEpgLocalName" {
  name = "web_epg"
  application_profile_dn = aci_application_profile.apLocalName.id
  relation_fv_rs_bd = aci_bridge_domain.bdLocalName.id
  pref_gr_memb = "include"
}