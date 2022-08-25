output "all" {
  value = local.all
}

output "volumes" {
  value = flatten([for i in data.aws_ebs_volumes.volumes : i.ids])
}

output "new_volumes" {
    value = concat([ for v in aws_ebs_volume.new_root_volumes : v.id ], [ for v in aws_ebs_volume.new_ebs_volumes : v.id ])
}