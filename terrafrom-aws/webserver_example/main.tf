########################### SOURCE ###################################
## youtube : https://www.youtube.com/watch?v=SLB_c_ayRMo
## github : https://github.com/Sanjeev-Thiyagarajan/Terraform-Crash-Course/blob/master/main.tf
######################################################################


# doesn't need to be called as main.tf. it can be <anything>.tf 
# providers are the plugin that allows us to talk to a specific set of API. https://www.terraform.io/language/providers

# Configure the AWS Provider
# run the following in the terminal
# export AWS_ACCESS_KEY_ID="<your access key id>"
# export AWS_SECRET_ACCESS_KEY="<your secret key>"
# export AWS_REGION="us-east-1"
provider "aws" { }

# creating an ec2 with resource "aws_<resource>" "<name>"
# here the name is only scoped to terrafrom and NOT to AWS

resource "aws_instance" "my_aws_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "Ravi_Terrafrom_Learning_2"
    Billing = "free-tier"
  }

}


# Execution notes
# =========================================================================================
# terraform init ---> it looks at the config (i.e all tf files), will check the provider(s) and downloads the necessary plugins to interact with the necessary APIs 
# terraform plan ---> dry run your code
# terraform apply --> actual run, it will ask for confirmation
# Terraform is written in "Declarative" style. We give the instructions on how our infrastructure should look at the end, rather than the actual execution plan/steps. because of this even if you run terraform apply again, it will say "Apply complete! Resources: 0 added, 0 changed, 0 destroyed." 
# terraform destroy --> deletes all the resources and associated services


# Folders
# ===========================================================================================
# .terraform is a hidden folder created when we do terraform init ( our dependent providers are downloaded here)
# terraform.tfstate --> represents all the state, all the resources that terraform has created. deleting this file will break the code.data 





