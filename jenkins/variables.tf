variable "vpc_id" {
  description = "VPC ID where Jenkins will be deployed"
  type        = string
  default     = "vpc-055fd63de62c80033"
}

variable "subnet_id" {
  description = "Subnet ID where Jenkins will be deployed"
  type        = string
  default     = "subnet-061186a5846709fdd"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "aws"
}