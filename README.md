# AWS SSM EC2 Terraform module

Terraform module which creates an SSM compatible EC2 instance on AWS. By default, uses KMS encrypted storage.

## Usage

```hcl
module "ec2" {
  source = "github.com/stuxcd/terraform-aws-ssm-ec2"

  ## either
  vpc_id    = "vpc-1234567890"
  subnet_id = "subnet-1234567890"
  ## or
  launch_template_name = "my-custom-launch-template"

  ## optional
  # additional_security_group_ids = []
  # launch_template_version       = ""
}
```