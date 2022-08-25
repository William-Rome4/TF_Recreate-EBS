locals {
  volumes = flatten([ for i in data.aws_ebs_volume.new_volumes : i ])
}