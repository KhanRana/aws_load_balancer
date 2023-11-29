# create a vpc
module "networking" {
  source = "./modules/networking"

  vpc_name           = "smart_home_vpc"
  cidr_range         = "10.0.0.0/20"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}

# create security group
module "security" {
  source = "./modules/security"

  vpc_id = module.networking.vpc_id
}

# create instance and attach the security group
module "smart_home_server" {
  source          = "./modules/smart_home_server"
  subnet_id       = module.networking.public_subnets
  security_groups = [module.security.security_group_id]
  key_pair        = "MyKeyPair"
  ec2_name        = ["smart_home_001", "smart_home_002", "smart_home_003"]
}

# create load balancer and attach instances running the application
module "load_balancing" {
  source          = "./modules/load_balancing"
  vpc_id          = module.networking.vpc_id
  ec2_id          = module.smart_home_server.instance_id
  security_groups = [module.security.security_group_id]
  subnets         = module.networking.public_subnets
}


