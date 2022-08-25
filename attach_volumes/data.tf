data "aws_ebs_volume" "new_volumes" {
  most_recent = true
  for_each = toset(var.ebs_list)

  filter {
    name   = "volume-id"
    values = [ each.key ]
  }
}