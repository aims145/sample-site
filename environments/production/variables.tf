variable "env" {
  default = "undefined"
}

variable "region" {
  default = "eu-central-1"
}

variable "zones" {
  default = ["a", "b", "c"]
}

variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  default = {
    zone0 = "10.100.10.0/24"
    zone1 = "10.100.20.0/24"
    zone2 = "10.100.30.0/24"
  }
}

variable "private_subnet_cidr_blocks" {
  default = {
    zone0 = "10.100.11.0/24"
    zone1 = "10.100.21.0/24"
    zone2 = "10.100.31.0/24"
  }
}
