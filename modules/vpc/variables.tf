variable "env" {
  default = "undefined"
}

variable "region" {
  default = "us-west-1"
}

variable "zones" {
  default = ["a", "b", "c"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  default = {
    zone0 = "10.0.10.0/24"
    zone1 = "10.0.20.0/24"
    zone2 = "10.0.30.0/24"
  }
}

variable "private_subnet_cidr_blocks" {
  default = {
    zone0 = "10.0.11.0/24"
    zone1 = "10.0.21.0/24"
    zone2 = "10.0.31.0/24"
  }
}
