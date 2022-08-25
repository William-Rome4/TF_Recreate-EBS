locals {
  instances = [ for i in data.aws_instance.instances : i.id ]
  volumes = [ for i in data.aws_ebs_volumes.volumes : i.ids ]
  volumes_len = [ for x in local.volumes : length(x) ]
  # Este local abaixo faz uma relação na escala 1:1 de cada instância à qual o volume é referente
  relation = flatten([ for i in local.volumes_len: i > 1 ? [ for x in range(i) : data.aws_instance.instances[local.instances[index(local.volumes_len, i)]].id ] : [ data.aws_instance.instances[local.instances[index(local.volumes_len, i)]].id ] ])
  ebs_volumes = flatten([ for i in data.aws_instance.instances : i.ebs_block_device[*] ])
  root_volumes = flatten([ for i in data.aws_instance.instances : i.root_block_device[*] ])
  all = zipmap(flatten(local.volumes), local.relation)
}