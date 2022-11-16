#!/usr/bin/env python
from constructs import Construct

from cdktf import App, TerraformStack


from imports.aci import provider

from imports.aci import tenant

from imports.aci import vrf

from imports.aci import bridge_domain
from imports.aci import subnet

from imports.aci import application_profile
from imports.aci import application_epg


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)
        
        aci = provider.AciProvider(self, "aci_provider",
            url = "https://10.10.20.14",
            username = "admin",
            password = "C1sco12345",
            insecure = True
        )

        # define resources here

        ## Tenant 
        terraform_cdktf_tenant = tenant.Tenant(self, "terraform_cdktf_tenant",
        name = "terraform_cdktf_tenant",
        description = "This tenant was built with CDKTF using Pyhton"
        )

        ## VRF
        terraform_cdktf_vrf = vrf.Vrf(self, "terraform_cdktf_vrf",
        name = "terraform_cdk_VRF",
        tenant_dn = terraform_cdktf_tenant.id)

        ## BD

        terraform_cdktf_bd_1 = bridge_domain.BridgeDomain(self, "terraform_cdktf_bd_1",
        name = "terraform_cdktf_bd_1",
        tenant_dn = terraform_cdktf_tenant.id,
        relation_fv_rs_ctx = terraform_cdktf_vrf.id)

        ## Subnet
        terraform_cdktf_subnet_1 = subnet.Subnet(self, "terraform_cdktf_subnet_1",
        parent_dn = terraform_cdktf_bd_1.id,
        ip = "10.0.0.1/24",
        scope = [ "public" ]
        )

        ## Application Profile

        terraform_cdktf_app = application_profile.ApplicationProfile(self, "terraform_cdktf_app",
        name = "terraform_cdktf_app",
        tenant_dn = terraform_cdktf_tenant.id)
        
        ## EPG

        terraform_cdktf_epg_1 = application_epg.ApplicationEpg(self, "terraform_cdktf_epg_1",
        name = "terraform_cdktf_epg_1",
        application_profile_dn= terraform_cdktf_app.id,
        relation_fv_rs_bd = terraform_cdktf_bd_1.id)


app = App()
MyStack(app, "cdktf")

app.synth()


