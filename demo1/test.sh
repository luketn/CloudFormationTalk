#!/usr/bin/env bash

echo "Testing that the site is running..."
PAGE=$(curl $1)

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