data "aws_instance" "instances" {
  for_each = toset(var.ec2_list)
  instance_id = each.key
}

data "aws_ebs_volumes" "volumes" {
  for_each = toset(local.instances)

  filter {
    name   = "attachment.instance-id"
    values = [each.key]
  }
}