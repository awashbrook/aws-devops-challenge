#!/bin/sh -x
terraform plan -out tf.plan && \
    terraform show -no-color tf.plan > tf.plan.txt