#!/bin/sh -x

./lint.sh && ./plan.sh && terraform apply tf.plan