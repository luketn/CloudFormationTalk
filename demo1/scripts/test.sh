#!/usr/bin/env bash

SUBDOMAIN=$1

echo "Testing that the site is running..."
PAGE=$(curl "https://"$SUBDOMAIN".mycodefu.com")

if [ "$PAGE" == "Welcome to CloudFront - This site was built and deployed with CloudFormation." ]
then
  echo "
--------
Success!
--------

Result:
"$PAGE
  exit 0
else
  echo "
-----
FAIL!
-----

Result:
"$PAGE
  exit 1
fi