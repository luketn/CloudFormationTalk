#!/usr/bin/env bash
SUBDOMAIN=$1
aws s3 sync ../site/ s3://$SUBDOMAIN-site/
