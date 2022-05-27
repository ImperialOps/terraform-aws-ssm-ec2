#################################
# PROVIDER
#################################

provider "aws" {
  region = "eu-west-2"
}

#################################
# COMPUTE
#################################

module "ec2" {
  source = "../.."

  ## required
  vpc_id    = ""
  subnet_id = ""
}

output "ec2_instance_name" {
  value = module.ec2.ec2_instance_name
}