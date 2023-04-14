##########################################
# COMPUTE
##########################################

output "ec2_instance_name" {
  value       = local.global_name
  description = "The name of the EC2 instance created"
}

output "role_arn" {
  value       = try(module.role.iam_role_arn, "")
  description = "The ARN of the role created"
}
