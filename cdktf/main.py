#!/usr/bin/env python
from constructs import Construct

from cdktf import App, TerraformStack

from . import provider


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)
        
        provider.AciProvider(self, )

        # define resources here


app = App()
MyStack(app, "cdktf")

app.synth()
