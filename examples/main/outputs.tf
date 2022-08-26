#################################
# COMPUTE
#################################

output "ec2_instance_name" {
  value       = module.ec2.ec2_instance_name
  description = "The name of the EC2 instance created"
}
