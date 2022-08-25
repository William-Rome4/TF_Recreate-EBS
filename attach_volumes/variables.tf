variable "ebs_list" {
  type = list(string)
  
  description = "List of the new EBS volumes created from the old ones' snapshots"
}