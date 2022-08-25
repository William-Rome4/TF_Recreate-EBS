# Terraform: Recreate EBS Volumes

### This project aims to automate the recreation of EBS volumes attached to Running EC2 instances on AWS

<br>

## ☕ Follow these steps to use this project

<br>

## :one: Clone the Repo into your machine

```Shell
git clone https://github.com/William-Rome4/TF_Recreate-EBS.git
```

<br>

## :two: Configure the *providers.tf* files to use AWS CLI

```tf
provider "aws" {
  region = "sa-east-1"
  profile = "AWS_Admin"
}
```

> [You need to have a configured AWS CLI profile for this to work](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
<br>

## :three: Enter the **/create_volumes** directory and Initialize Terraform

```tf
cd create_volumes

terraform init
```

<br>

## :four: Create a *.tfvars* file with the variable ec2_list set

```Shell
touch ec2.auto.tfvars

echo "ec2_list = ["<InstanceID_1>", "<InstanceID_2>", "<InstanceID-3>"]" > ec2.auto.tfvars
```

<br>

## :five: Run terraform plan > apply to provision the resources

```tf
terraform plan

terraform apply -auto-approve
```

>This step will make a snapshot for each volume detected and create a new EBS volume from them

### :exclamation: Save the Volume IDs returned by the *new_volumes* output :exclamation

<br>

## :six: Comment the whole *attachments.tf* file and run apply again

```Ruby
:Editing attachments.tf:

/* resource "aws_volume_attachment" "detach_ebs" {
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
} */
```

```tf
terraform apply
```

>When commenting the aws_volume_attachment resource, we are telling Terraform to destroy them. <br>
>That way, the EBS volumes are detached from their instances.
<br>

## :seven: Move to the /attach_volumes directory & create a *.tfvars* file with ebs_list set

```Shell
cd ..
cd attach_volumes

touch ebs.auto.tfvars
echo "ebs_list = [<Paste the output noted on step 5]" > ebs.auto.tfvars
```

<br>

## :eight: Run terraform apply to attach the new EBS volumes to their respective instances

```tf
terraform plan

terraform apply -auto-approve
```

<br>

## :nine: Start the instances using AWS CLI

:grey_question: Terraform isn't fitted for starting/stopping resources at will :grey_question:

```aws
aws ec2 start-instances --instance-ids "<id-1>" "<id-2>" "<id-3>" ...
```

<br>

## :keycap_ten: Voilà! Your instances have been equipped with brand new EBS volumes

<br>

# :open_book: Documentation Used

-[Terraform HCL](https://www.terraform.io/language) &emsp;&emsp; -[Terraform Registry - AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
