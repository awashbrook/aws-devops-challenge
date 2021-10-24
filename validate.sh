#!/bin/sh

tflint && terraform validate && terraform fmt
