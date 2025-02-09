#DEFINE DEFAULT VARIABLES HERE

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
}


variable "key_name" {
  description = "Key name for EC2"
  type        = string
}

variable "volume_size" {
  description = "Volume size"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
  type        = string
}

variable "default_subnet_id" {
  description = "EC2 default subnet id"
  type        = string
}

variable "instance_name" {
  type        = string
}