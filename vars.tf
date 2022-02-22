##########################################
# NETWORKING
##########################################

variable "vpc_id" {
  type        = string
  description = "Identifier of VPC to deploy EC2 instance into"
}

variable "subnet_id" {
  type        = string
  description = "Identifier of subnet to deploy EC2 instance into"
}

##########################################
# LAUNCH TEMPLATE
##########################################

variable "launch_template_id" {
  type        = string
  description = "Identifier of lauch template to deploy EC2 from, bring your own EC2"
  default     = ""
}

##########################################
# IAM
##########################################

variable "additional_security_group_ids" {
  type        = list(string)
  description = "Identifier of custom security group ID, replaces default"
  default     = []
}