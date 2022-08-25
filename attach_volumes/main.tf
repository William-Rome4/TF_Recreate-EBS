resource "aws_volume_attachment" "attach_new_volumes" {
  count = length(local.volumes)
  device_name = lookup(local.volumes[count.index].tags, "Device Name")
  volume_id = local.volumes[count.index].id
  instance_id = lookup(local.volumes[count.index].tags, "Vol-InstanceID")
}