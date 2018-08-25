# CloudFormation Talk
Build a CloudFront distribution and migrate to it from another CDN using CloudFormation.

#### Requirements
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

The demo is in two parts:
* demo #1: Build a simple CloudFront application with CloudFormation
* demo #2: Transition from an existing CDN to CloudFront using Weighted routing DNS in Route53
 
 
# Demo 1

# Demo 2

Let's first go back to Demo #1 and make a small change to it:

Convert the DNS record type from:
```bash
      Type: A
      AliasTarget:
        DNSName: !GetAtt CFDistribution.DomainName
        HostedZoneId: "Z2FDTNDATAQYW2"
``` 
to
```bash
      Type: CNAME
      ResourceRecords:
        - !GetAtt CFDistribution.DomainName
      SetIdentifier: CDN_OLD
      Weight: 0
      TTL: 10
```

(on branch alternate-demo1)

Then we can deploy a new set of DNS record alternatives:

```bash
cd demo2
./deploy.sh
```
