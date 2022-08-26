##########################################
# COMPUTE
##########################################

output "ec2_instance_name" {
  value       = local.global_name
  description = "The name of the EC2 instance created"
}
