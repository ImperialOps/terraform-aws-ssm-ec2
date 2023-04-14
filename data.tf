#################################
# AWS
#################################

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

#################################
# AMI
#################################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
