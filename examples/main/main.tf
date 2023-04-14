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

  tags = {
    project_code = "PO-1234"
  }
}
