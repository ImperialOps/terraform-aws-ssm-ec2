#################################
# PROVIDER
#################################

provider "aws" {
  region = "eu-west-2"
}

#################################
# EXAMPLE
#################################

module "ec2" {
  source = "../.."

  ## required
  vpc_id    = ""
  subnet_id = ""

  ## optional
  # additional_security_group_ids = []
  # launch_template_id            = ""
}