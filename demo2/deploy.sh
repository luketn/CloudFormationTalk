#!/usr/bin/env bash

SUBDOMAIN=${1:-cfn-cf-demo1}

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file route53-transition.yml --stack-name $SUBDOMAIN-weighted-dns \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "LegacyCDNDomain=ec2-52-64-14-196.ap-southeast-2.compute.amazonaws.com" \
            "LegacyCDNDomainWeight=100" \
            "CDNDomain=dwq56229s1oyz.cloudfront.net" \
            "CDNDomainWeight=0"

aws cloudformation describe-stacks --stack-name $SUBDOMAIN-weighted-dns --query 'Stacks[].Outputs[]' --output table

echo "Finished CloudFormation deploy at "`date`

../demo1/test.sh "https://"$SUBDOMAIN".mycodefu.com"