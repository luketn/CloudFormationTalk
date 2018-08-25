#!/usr/bin/env bash

SUBDOMAIN=$1
aws cloudformation describe-stacks --stack-name $SUBDOMAIN --query 'Stacks[].Outputs[]' --output table
