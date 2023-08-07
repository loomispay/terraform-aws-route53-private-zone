# Overview

The key concept of this module is to make possible to create association authorization between private zone and target VPC.
The entire solution is based on the fact that each of the modules provided here will be applied to a separate account
To avoid using provider and make modules easier to use by Terragrunt the repository has been split to two different modules: 

- **modules/zone** - copy of official terraform-aws-route53 by resource aws_route53_vpc_association_authorization to store it also as a IaC
- **modules/authorities** - module should be applied on the account to which VPC should have access zone