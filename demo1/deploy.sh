#!/usr/bin/env bash

SUBDOMAIN=${1:-cfn-cf-demo1}

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file cfn-cf-demo1.yml --stack-name $SUBDOMAIN \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "S3BucketName="$SUBDOMAIN"-site" \
            "TlsCertificateArn=arn:aws:acm:us-east-1:204244381428:certificate/47534d52-e75c-40e0-b4ed-c4a8d0a62ba6"

aws cloudformation describe-stacks --stack-name $SUBDOMAIN --query 'Stacks[].Outputs[]' --output table

echo "Finished CloudFormation deploy at "`date`

aws s3 cp ./index.html s3://$SUBDOMAIN-site/index.html

./test.sh "https://"$SUBDOMAIN".mycodefu.com"