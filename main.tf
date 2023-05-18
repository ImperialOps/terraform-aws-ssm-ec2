##########################################
# GENERAL
##########################################

locals {
  global_name = random_pet.global_name[0].id

  create                      = var.create
  create_supporting_resources = local.create && !local.use_launch_template

  use_launch_template = var.launch_template_name != ""

  tags = var.tags
}

resource "random_pet" "global_name" {
  count = local.create ? 1 : 0

  length = 4
}

##########################################
# COMPUTE
##########################################

locals {
  device_mappings = [for device in data.aws_ami.ubuntu.block_device_mappings : device if device.virtual_name == ""]
}

resource "aws_instance" "standalone" {
  count = local.create_supporting_resources ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_size
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
      kms_key_id            = data.aws_kms_key.ebs.arn
      volume_size           = ebs_block_device.value.ebs.volume_size
      volume_type           = ebs_block_device.value.ebs.volume_type
    }
  }

  tags        = merge(local.tags, { Name = local.global_name })
  volume_tags = merge(local.tags, { Name = local.global_name })
}

resource "aws_instance" "launch_template" {
  count = local.create && local.use_launch_template ? 1 : 0

  launch_template {
    name    = var.launch_template_name
    version = var.launch_template_version
  }

  tags = merge(local.tags, { Name = local.global_name })
}

##########################################
# IAM
##########################################

resource "aws_iam_instance_profile" "this" {
  count = local.create_supporting_resources ? 1 : 0

  role = module.role.iam_role_name

  tags = local.tags
}

module "role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.19.0"


  create_role       = local.create_supporting_resources
  role_name         = local.global_name
  role_requires_mfa = false

  trusted_role_services = ["ec2.amazonaws.com"]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  number_of_custom_role_policy_arns = 1

  tags = local.tags
}

##########################################
# NETWORKING
##########################################

resource "aws_security_group" "this" {
  count = local.create_supporting_resources ? 1 : 0

  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Name = local.global_name })
}

resource "aws_security_group_rule" "this" {
  count = local.create_supporting_resources ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[0].id
}
