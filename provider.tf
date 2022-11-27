variable "region" {
  default = "eu-west-2"
  description = "aws region"
}


variable "cidr_block" {
  default = "10.0.0.0/16"
  description = "vpc cidr"
}


variable "publicsub-1-cidr_block" {
  default = "10.0.1.0/24"
  description = "publicsub-1 cidr"
}


variable "publicsub-2-cidr_block" {
  default = "10.0.2.0/24"
  description = "publicsub-2 cidr"
}


variable "privatesub-1-cidr_block" {
  default = "10.0.3.0/24"
  description = "privatesub-1 cidr"
}


variable "privatesub-2-cidr_block" {
  default = "10.0.4.0/24"
  description = "privatesub-2 cidr"
}