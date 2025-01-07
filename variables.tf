variable "aws_vpc_cidr" {
  default     = "142.168.0.0/22"
  description = "CIDR for creating VPC in US_EAST"
}

variable "aws_sub_pub1" {
  default     = "142.168.0.0/24"
  description = "CIDR for Public_Subnet1"
}

variable "aws_sub_pub2" {
  default     = "142.168.1.0/24"
  description = "CIDR for Public_Subnet2"
}

variable "aws_sub_pri1" {
  default     = "142.168.2.0/24"
  description = "CIDR for Private_Subnet1"
}

variable "aws_sub_pri2" {
  default     = "142.168.3.0/24"
  description = "CIDR for Private_Subnet2"
}

