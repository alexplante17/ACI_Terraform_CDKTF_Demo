#!/usr/bin/env python
from constructs import Construct

from cdktf import App, TerraformStack

#from . import AciProvider
from imports.aci import provider
from imports.aci import tenant


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)
        
        aci = provider.AciProvider(self, "aci_provider",
            url = "https://10.10.20.14",
            username = "admin",
            password = "C1sc012345",
            insecure = True
        )

        # define resources here

        vanilla_tenant = tenant.Tenant(self,
        name = "terraform_cdktf_tenant",
        description = "This tenant was built with CDKTF using Pyhton"
        )


app = App()
MyStack(app, "cdktf")

app.synth()


