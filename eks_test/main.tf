terraform {
    backend "s3" {
        bucket = "terraform-states"
        region = "ap-south-1"
        profile = "terraform"
        key = "prod/ekscg/terraform.tfstate"
        role_arn = "arn:aws:iam::4245037:role/terraform"
        session_name = "terraform"
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.14.0"
        }
    }
}
provider "aws" {
    region = "ap-south-1"
    profile = "terraform"
    assume_role {
      role_arn = "arn:aws:iam::4245:role/terraform"
    }
}

module "eksClusterRole" {
    source = "../modules/iam_role"
    name = "eksClusterRole"
    allowed_service_policy = file("${path.module}/eksassumerolepolicy.json")
    policy_arns = [
        #"arn:aws:iam::aws:policy/AmazonEKSServicePolicy", #Required Prior to April 16, 2020
        #"arn:aws:iam::aws:policy/AmazonEKSVPCResourceController", # Optionally, enable Security Groups for Pods. Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    ]
}
/*
module "eksNodeInstanceRole" {
    source = "../modules/iam_role"
    name = "eksNodeInstanceRole"
    allowed_service_policy = file("${path.module}/nodeinstanceassumerolepolicy.json")
    policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        #"arn:aws:iam::aws:policy/AmazonEKSWorkernodePolicy" # Bug in AWS provider which doesnt allow inline creation of policies
    ]
    enable_instance_profile = true
}
# May be removed in future if the bug fixes in AWS provider
resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = module.eksNodeInstanceRole.RoleName
}
*/
resource "aws_iam_role" "eksNodeInstanceRole" {
    name = "eksNodeInstanceRole"
    force_detach_policies = true
    assume_role_policy = <<-EOF
        {
            "Version": "2012-10-17",
            "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
            ]
        }
    EOF
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksNodeInstanceRole.id
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksNodeInstanceRole.id
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksNodeInstanceRole.id
}

resource "aws_iam_instance_profile" "eksNodeInstanceRoleProfile" {
  name  = "eksNodeInstanceRoleProfile"
  role  = aws_iam_role.eksNodeInstanceRole.id
}


module "EKSSecurityGroup" {
    source = "../modules/security_group"
    environment= "dev"
    project = "yekstest"
    service = "eks-service"
    #create_security_group = false
    vpc_id = "vpc-0d26ee546c914d60d"
    security_group_id = "sg-006b047beb211a1da"
    #security_group_name = "prod-ytest-vpc-SecurityGroup"
    rules = [
        {
            rule_type = "ingress"
            cidr_blocks = ["0.0.0.0/0"]
            from_port = 0
            to_port = 65535
            protocol = "tcp"
        }
    ]
    
}
module "eks" {
    source = "../modules/eks"
    depends_on = [
        module.eksClusterRole,
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
        #module.eksNodeInstanceRole, 
        #aws_iam_role_policy_attachment.AmazonEKSServicePolicy
    ]
    name = "yekstest"
    eks_cluster_role_arn  = module.eksClusterRole.RoleArn
    subnet_ids = [
        "subnet-0799dd8431a6746a0",
        "subnet-064bdd1ad328c415f",
        "subnet-0c257ca08f8c2f74e"
    ]
    kubernetes_version = "1.18"
    node_instance_profile_arn =  aws_iam_instance_profile.eksNodeInstanceRoleProfile.arn
    security_group = "sg-006b047beb211a1da"
}
