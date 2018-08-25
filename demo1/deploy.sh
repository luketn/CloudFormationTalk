#!/usr/bin/env bash

SUBDOMAIN=${1:-cfn-cf-demo1}

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file cfn-cf-demo1.yml --stack-name $SUBDOMAIN \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "S3BucketName="$SUBDOMAIN"-site"

aws cloudformation describe-stacks --stack-name $SUBDOMAIN --query 'Stacks[].Outputs[]' --output table

echo "Finished CloudFormation deploy at "`date`

aws s3 cp ./index.html s3://$SUBDOMAIN-site/index.html

./test.sh "http://"$SUBDOMAIN".mycodefu.com"