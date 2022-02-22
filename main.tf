##########################################
# GENERAL
##########################################

locals {
  global_name = random_pet.global_name.id

  # optional variables
  launch_template = var.launch_template_name != "" ? true : false
}

resource "random_pet" "global_name" {
  length = 4
}

##########################################
# ENCRYPTION
##########################################

resource "aws_kms_key" "ec2_volume" {
  count = local.launch_template ? 0 : 1

  description             = "KMS key for EC2 EBS volume"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.ec2_volume.json
}

##########################################
# NETWORKING
##########################################

resource "aws_security_group" "this" {
  count = local.launch_template ? 0 : 1

  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "this" {
  count = local.launch_template ? 0 : 1

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[0].id
}

##########################################
# IAM
##########################################

resource "aws_iam_instance_profile" "this" {
  count = local.launch_template ? 0 : 1

  role = aws_iam_role.this[0].name
}

resource "aws_iam_role" "this" {
  count = local.launch_template ? 0 : 1

  name               = local.global_name
  description        = "The role for the SSM EC2 instance"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.launch_template ? 0 : 1

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##########################################
# COMPUTE
##########################################

locals {
  device_mappings = [for device in data.aws_ami.ubuntu.block_device_mappings : device if device.virtual_name == ""]
}

resource "aws_instance" "standalone" {
  count = local.launch_template ? 0 : 1

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.small"
  subnet_id     = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.this[0].id

  vpc_security_group_ids = concat(
    [aws_security_group.this[0].id],
    var.additional_security_group_ids
  )

  dynamic "ebs_block_device" {
    for_each = local.device_mappings

    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_volume[0].id
      volume_size           = ebs_block_device.value.ebs.volume_size
      volume_type           = ebs_block_device.value.ebs.volume_type
    }
  }

  tags = {
    Name = local.global_name
  }
}

resource "aws_instance" "launch_template" {
  count = local.launch_template ? 1 : 0

  launch_template {
    name    = var.launch_template_name
    version = var.launch_template_version
  }

  tags = {
    Name = local.global_name
  }
}