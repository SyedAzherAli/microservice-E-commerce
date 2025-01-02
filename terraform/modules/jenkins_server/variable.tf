variable "key_name" {
  description = "Enter key name"  // *
}
variable "subnet_id" {
  description = "Enter subnet id " // *
}
variable "sg_vpc_id" {
  description = "vpc id for security group" // *
}
variable "instance_type" {
  description = "Type of Instance specs ex: t2.micro, t2.medium. t2.large"
  default = "t2.medium"
}
variable "volume_size" {
  description = "Size the server"
  default = 12
}
variable "user_data" {
  description = "User data for the instance" // *
}