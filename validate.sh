#!/bin/sh -x

tflint && terraform validate && terraform fmt
