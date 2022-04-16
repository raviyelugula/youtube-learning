### This project is exactly or slightly modified version of the tutorial on terraform by [freecodecamp.org, youtube, Learn Terraform and AWS by Building a Dev Environment – Full Course for Beginners](https://www.youtube.com/watch?v=iRaai1IBlB0)

# Big Thanks to Derek Morgan !!!
## Objective
## Design
## Steps
---
# NOTES 
---
## Providers
    1. mention all the providers you need 
## Terraform Commands
**terraform init** --> 
    1. This will initialize the terrform by installing necessary providers.
    2. Under .terraform/.terraform.lock.hcl records the provider selections it made above. Include this file in your version control repository so that Terraform can guarantee to make the same selections by default when you run "terraform init" in the future.

**terraform plan**

**terraform apply** 

**terraform apply -auto-approve**

**terraform apply -replace**

**terraform destroy** 

**terraform fmt**

**terraform console**

**terraform console -var="ssh-config=hai"**

**terraform console -var-file="dev.tfvars"**

**terraform apply refresh**

**terraform output**

### State 
    1. terraform.tfstate is created after giving terraform apply, this is generally stored in terraform cloud or aws cloud etc.. DO NOT ALTER this file
    2. to access this state file 
        2.1. **terraform state list** --> list of all resources you created using this folder terrafrom
        2.2. **terraform state show <aws-resource-syntax>.<terraform-resource-name>** --> gives the details of that resource.

 

### VPC 
Virtual Private Cloud

### Subnets
Divide VPC into small groups, can give different rules on each subnet thus improving security.

### CIDR
    Classless Inter-Domain Routing [quick reference video](https://www.youtube.com/watch?v=aPW-ZAo09Pg)
    1. Can define the IP address pattern and how many we will allow to have.
    2. example 172.31.12.0/24 CIDR block notation, this notation contains <network portion - 172.31.12><host portion - 0>. This portion split is happened because we defined 24 bits are network by giving /24.
        octate1 ( 8 bit ) - 172
        octate2 ( 8 bit ) - 31
        octate3 ( 8 bit ) - 12
        octate4 ( 8 bit ) - 0
        toal ( 32 bit ) - 172.31.0.0
        Here host portion is 8 bits i,e 2^8 = 256 ( ip address can be generated in the n/w 172.31.0.[0-255])
    3. example2, a vpc with 2 subnets and each should have 100 ips capcaity: 
        VPC CIDR = 172.31.12.0/24
        Subnet1 CIDR = 172.31.12.0/25 --> here network got 25 bits and only last octate's 7 bits are assigned for host. so 2^7 = 128 ips only can be generated here [0-127]
        Subnet2 CIDR = 172.31.12.128/25 --> here network got 25 bits and only last octate's 7 bits are assigned for host. so 2^7 = 128 ips only can be generated here [128-155]






