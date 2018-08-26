#!/usr/bin/env bash

SUBDOMAIN=$1

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file ../template.yml --stack-name $SUBDOMAIN \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "S3BucketName="$SUBDOMAIN"-site" \
            "TlsCertificateArn=arn:aws:acm:us-east-1:204244381428:certificate/47534d52-e75c-40e0-b4ed-c4a8d0a62ba6"
echo "Finished CloudFormation deploy at "`date`

