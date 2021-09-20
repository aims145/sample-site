variable "env" {
  default = "undefined"
}

variable "region" {
  default = "us-east-1"
}

variable "zones" {
  default = ["a", "b", "c"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}