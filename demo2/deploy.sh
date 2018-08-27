#!/usr/bin/env bash

# Percentage transitioned from legacy is the 1st parameter - a value between 0 and 100
declare -i CLOUDFRONT_WEIGHT
CLOUDFRONT_WEIGHT=${1:-0}
LEGACY_WEIGHT=$(expr 100 - $CLOUDFRONT_WEIGHT)

SUBDOMAIN=${2:-cfn-cf-demo2}
CLOUDFRONT_DOMAIN=${3:-awesome-and-thrifty.cloudfront.com}
LEGACY_DOMAIN=${4:-awesome-but-pricey.cdn.com}

echo "Parameters passed:
./deploy.sh "$CLOUDFRONT_WEIGHT" "$SUBDOMAIN" "$CLOUDFRONT_DOMAIN" "$LEGACY_DOMAIN"
"

echo "Started CloudFormation deployment of "$SUBDOMAIN".mycodefu.com, "$CLOUDFRONT_WEIGHT"% migrated ("$LEGACY_WEIGHT"% legacy) at "`date`"..."
aws cloudformation deploy --region us-east-1 --template-file template.yml --stack-name $SUBDOMAIN-weighted-dns \
        --parameter-overrides \
            "HostedZoneName=mycodefu.com." \
            "WebsiteAddress="$SUBDOMAIN".mycodefu.com" \
            "LegacyCDNDomain="$LEGACY_DOMAIN \
            "LegacyCDNDomainWeight="$LEGACY_WEIGHT \
            "CDNDomain="$CLOUDFRONT_DOMAIN \
            "CDNDomainWeight="$CLOUDFRONT_WEIGHT

aws cloudformation describe-stacks --stack-name $SUBDOMAIN-weighted-dns --query 'Stacks[].Outputs[]' --output table

echo "Finished CloudFormation deploy at "`date`

echo "Check deployment propogation at:
https://dnschecker.org/#CNAME/"$SUBDOMAIN".mycodefu.com
or
https://www.whatsmydns.net/#CNAME/"$SUBDOMAIN".mycodefu.com
"