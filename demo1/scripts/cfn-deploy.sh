#!/usr/bin/env bash

SUBDOMAIN=$1

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file ../template.yml --stack-name $SUBDOMAIN \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "S3BucketName="$SUBDOMAIN"-site"
echo "Finished CloudFormation deploy at "`date`

