module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "skillnest-vpc"
  cidr = "172.20.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["172.20.1.0/24", "172.20.2.0/24"]
  public_subnets  = ["172.20.3.0/24", "172.20.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}