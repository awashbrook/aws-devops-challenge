#!/bin/sh -x

terraform plan -destroy -out=destroy.tfplan && \
    terraform apply destroy.tfplan