##########################################
# COMPUTE
##########################################

variable "instance_size" {
  type        = string
  description = "Size of the EC2 instance to deploy"
  default     = "t3a.small"
}

##########################################
# NETWORKING
##########################################

variable "vpc_id" {
  type        = string
  description = "Identifier of VPC to deploy EC2 instance into"
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = "Identifier of subnet to deploy EC2 instance into"
}

##########################################
# LAUNCH TEMPLATE
##########################################

variable "launch_template_name" {
  type        = string
  description = "The name of the launch template"
  default     = ""
}

variable "launch_template_version" {
  type        = string
  description = "The launch template version"
  default     = "$Default"
}

##########################################
# IAM
##########################################

variable "additional_security_group_ids" {
  type        = list(string)
  description = "Identifier of custom security group ID, replaces default"
  default     = []
}