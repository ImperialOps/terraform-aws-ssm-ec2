# AWS SSM EC2 Terraform module :robot:

Terraform module which creates an SSM compatible EC2 instance on AWS. By default, uses KMS encrypted storage.

## Usage

```hcl
module "ec2" {
  source    = "github.com/stuxcd/terraform-aws-ssm-ec2"
  # version = ""

  ## required
  vpc_id    = "vpc-1234567890"
  subnet_id = "subnet-1234567890"

  ## optional
  # additional_security_group_ids = []
  # launch_template_name          = "my-custom-launch-template"
  # launch_template_version       = ""
  # instance_size                 = ""
}
```

<!-- BEGIN_TF_DOCS -->
{{ .Content }}
<!-- END_TF_DOCS -->
