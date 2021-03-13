### Misc Setup Notes

AWS supports Egress-only internet access using ipv6.

https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html

This requires enabling IPV6 for the VPC, Subnet, Instance, and Security Group.

It also appreas that `apt-get` in AWS comes configured with a us-east-N source mirror that doesn't support IPV6.

Use `sed` to remove the appropriate reference us-east/us-west, etc. and only use the base http://archive.ubuntu.com hostname.
