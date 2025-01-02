provider "aws" {
  region = "ap-south-1"
}
module "vpc" {
  source = "./modules/vpc"
}
module "security_group" {
  source = "./modules/security_group"

  sg_vpc_id = module.vpc.vpc_id
}
module "ecr_repos" {
  source            = "./modules/ecr_repos"
  repository_names = [
    "adservice",
    "cartservice",
    "checkoutservice",
    "currencyservice",
    "emailservice",
    "frontend",
    "loadgenerator",
    "paymentservice",
    "productcatalogservice",
    "recommendationservice",
    "shippingservice",
    "shoppingassistantservice"
  ]
}
module "jenkins_server" {
  source = "./modules/jenkins_server"

  key_name  = var.key_name
  subnet_id = module.vpc.pub_subnet01_id
  sg_vpc_id = module.vpc.vpc_id
  instance_type = "t2.large"
  user_data = "./jenkins-script.sh"
  volume_size = 25
}

# module "jump_server" {
#   source = "./modules/ec2"
#   ami = "ami-053b12d3152c0cc71"
#   instance_type = "t2.medium"
#   key_name  = var.key_name
#   subnet_id = module.vpc.pub_subnet01_id
#   security_group_id = module.security_group.security_group_id
#   user_data = "script.sh"
#   volume_size = 16
# }

# module "eks" {
#   source = "./modules/eks"
   
#   cluster_name = "my-eks-cluster"
#   key_name = var.key_name
#   sg_vpc_id = module.vpc.vpc_id
#   controller_subnet_ids = [module.vpc.pvt_subnet01_id, module.vpc.pvt_subnet02_id]
#   worker_subnet_ids = [module.vpc.pvt_subnet01_id, module.vpc.pvt_subnet02_id]
#   endpoint_public_access = false
#   on_demand_scaling = {
#     desired_size = 1
#     max_size     = 5
#     min_size     = 1
#   }
#   spot_scaling = {
#     desired_size = 1
#     max_size     = 5
#     min_size     = 1
#   }
#   addons = [
#     {
#     name    = "vpc-cni",
#     version = "v1.19.0-eksbuild.1"
#   },
#   {
#     name    = "kube-proxy"
#     version = "v1.31.3-eksbuild.2"
#   },
#   {
#     name = "eks-pod-identity-agent"
#     version = "v1.3.4-eksbuild.1"
#   },
#   {
#     name    = "aws-ebs-csi-driver"
#     version = "v1.37.0-eksbuild.1"
#   }
#   ]
  
# }











