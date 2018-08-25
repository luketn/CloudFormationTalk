#!/usr/bin/env bash

SUBDOMAIN=${1:-cfn-cf-demo1}

cd scripts
./cfn-deploy.sh $SUBDOMAIN
./cfn-describe.sh $SUBDOMAIN
./deploy-site.sh $SUBDOMAIN
./test.sh $SUBDOMAIN
