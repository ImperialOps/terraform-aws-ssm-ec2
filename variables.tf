##########################################
# GLOBAL
##########################################

variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

##########################################
# COMPUTE
##########################################

variable "instance_size" {
  type        = string
  description = "The size of the EC2 instance to deploy"
  default     = "t3.micro"
}

##########################################
# NETWORKING
##########################################

variable "vpc_id" {
  type        = string
  description = "The identifier of VPC to deploy EC2 instance into"
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = "The identifier of subnet to deploy EC2 instance into"
}

##########################################
# LAUNCH TEMPLATE
##########################################

variable "launch_template_name" {
  type        = string
  description = "The name of the launch template to use"
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
  description = "The identifier of a custom security group ID, replaces default"
  default     = []
}
