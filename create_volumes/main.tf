resource "aws_ebs_snapshot" "ebs_volumes" {
  for_each = toset([ for v in local.ebs_volumes : v.volume_id ])
  volume_id = each.key

  tags = data.aws_instance.instances[lookup(local.all, each.key)].tags
}

resource "aws_ebs_snapshot" "root_volumes" {
  for_each = toset([ for v in local.root_volumes : v.volume_id ])
  volume_id = each.key

  tags = data.aws_instance.instances[lookup(local.all, each.key)].tags
}

resource "aws_ebs_volume" "new_ebs_volumes" {
  depends_on = [
    aws_ebs_snapshot.ebs_volumes
  ]
  count = length(local.ebs_volumes)
  availability_zone = data.aws_instance.instances[lookup(local.all, local.ebs_volumes[count.index].volume_id)].availability_zone
  snapshot_id = aws_ebs_snapshot.ebs_volumes[local.ebs_volumes[count.index].volume_id].id
  size = local.ebs_volumes[count.index].volume_size
  #encrypted = true
  #kms_key_id = "<Insert your KMS key ARN here>"

  tags = merge(data.aws_instance.instances[lookup(local.all, local.ebs_volumes[count.index].volume_id)].tags, 
    {
      "Device Name" = "${local.ebs_volumes[count.index].device_name}", 
      "Vol-InstanceID" = "${data.aws_instance.instances[lookup(local.all, local.ebs_volumes[count.index].volume_id)].id}"
    }
  )
}

resource "aws_ebs_volume" "new_root_volumes" {
  depends_on = [
    aws_ebs_snapshot.root_volumes
  ]
  count = length(local.root_volumes)
  availability_zone = data.aws_instance.instances[lookup(local.all, local.root_volumes[count.index].volume_id)].availability_zone
  snapshot_id = aws_ebs_snapshot.root_volumes[local.root_volumes[count.index].volume_id].id
  size = local.root_volumes[count.index].volume_size
  #encrypted = true
  #kms_key_id = "<Insert your KMS key ARN here>"

  tags = merge(data.aws_instance.instances[lookup(local.all, local.root_volumes[count.index].volume_id)].tags, 
    {
      "Device Name" = "${local.root_volumes[count.index].device_name}", 
      "Vol-InstanceID" = "${data.aws_instance.instances[lookup(local.all, local.root_volumes[count.index].volume_id)].id}"
    }
  )
}