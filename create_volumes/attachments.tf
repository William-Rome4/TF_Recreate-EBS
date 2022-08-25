resource "aws_volume_attachment" "detach_ebs" {
  depends_on = [
    aws_ebs_snapshot.ebs_volumes
  ]
  count = length(local.ebs_volumes)
  device_name = local.ebs_volumes[count.index].device_name
  volume_id = local.ebs_volumes[count.index].volume_id
  instance_id = lookup(local.all, local.ebs_volumes[count.index].volume_id)
}

resource "aws_volume_attachment" "detach_root" {
  depends_on = [
    aws_ebs_snapshot.root_volumes
  ]
  count = length(local.root_volumes)
  stop_instance_before_detaching = true
  device_name = local.root_volumes[count.index].device_name
  volume_id = local.root_volumes[count.index].volume_id
  instance_id = lookup(local.all, local.root_volumes[count.index].volume_id)
}