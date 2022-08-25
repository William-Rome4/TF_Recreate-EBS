variable "ec2_list" {
  type = list(string)

  description = "List of the EC2 instances that you want to substitute the EBS volumes"
}