#!/usr/bin/env bash

SUBDOMAIN=${1:-cfn-cf-demo1}
CLOUDFRONT_DOMAIN=$2
declare -i CLOUDFRONT_WEIGHT
CLOUDFRONT_WEIGHT=$3
LEGACY_WEIGHT=$(expr 100 - $CLOUDFRONT_WEIGHT)

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com, "$CLOUDFRONT_WEIGHT"% migrated ("$LEGACY_WEIGHT"% legacy) at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file route53-transition.yml --stack-name $SUBDOMAIN-weighted-dns \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "LegacyCDNDomain=ec2-52-64-14-196.ap-southeast-2.compute.amazonaws.com" \
            "LegacyCDNDomainWeight="$LEGACY_WEIGHT \
            "CDNDomain="$CLOUDFRONT_DOMAIN \
            "CDNDomainWeight="$CLOUDFRONT_WEIGHT

aws cloudformation describe-stacks --stack-name $SUBDOMAIN-weighted-dns --query 'Stacks[].Outputs[]' --output table

echo "Finished CloudFormation deploy at "`date`

../demo1/test.sh "http://"$SUBDOMAIN".mycodefu.com"