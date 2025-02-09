module "security-group" {
    source = "./modules/security-group"
    vpc_id = "vpc-0cb1934a19b26c0d1" #Default vpc
}

module "iam-role" {
  source = "./modules/iam-role"
}

module "ec2" {
    source = "./modules/ec2"
    volume_size = 30
    key_name = "ec2-key" #Replace with your key-name without .pem extension.
    # First create a pem-key manually from the AWS console
    # Copy it in the same directory as your terraform code
    default_subnet_id = "subnet-08fb50dc184b773f5"
    instance_type = "t2.medium"
    ami = "ami-0e1bed4f06a3b463d"  #Ubuntu 22.04
    security_group_id = module.security-group.security_group_id
    iam_role_name   = module.iam-role.role_name
    instance_name = "Jenkins-Server"
}