##########################################
# GENERAL
##########################################

locals {
  global_name = random_pet.global_name.id

  # optional variables
  launch_template = var.launch_template_id != "" ? true : false
}

resource "random_pet" "global_name" {
  length = 4
}

##########################################
# ENCRYPTION
##########################################

resource "aws_kms_key" "ec2_volume" {
  description             = "KMS key for EC2 EBS volume"
  deletion_window_in_days = 10
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

  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
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
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##########################################
# COMPUTE
##########################################

resource "aws_instance" "ec2" {
  count = local.launch_template ? 0 : 1

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.small"
  subnet_id     = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.this[0].id

  vpc_security_group_ids = concat(
    [aws_security_group.this[0].id],
    var.additional_security_group_ids
  )

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 25
  }

  tags = {
    Name = local.global_name
  }
}