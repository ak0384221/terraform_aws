

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "revision-ec2"
}

variable "az-count" {
  default = 2
  type    = number

}

variable "vpc_custom_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "cidr block address of the vpc name custom"

}
