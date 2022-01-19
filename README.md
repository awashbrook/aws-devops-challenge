# aws-devops-challenge
## On MacOS
### Install AWS CLI and Configure Configure AWS access keys
> brew install aws

> aws configure
AWS Access Key ID [****************xxxx]: 
AWS Secret Access Key [****************xxxx]: 
Default region name [IGNORED]: 
Default output format [None]: 

Verify 
> aws sts get-caller-identity
{   "UserId": "AFUGDSPUGJADJFPJFDSAFJY",
    "Account": "000000000000",
    "Arn": "arn:aws:iam::000000000000:user/alice"

### Install and Configure Terraform
> brew install terraform

> terraform init

>terraform apply

### Override Default AWS_REGION of eu-west-1
Edit vars.tf or on cmd line -var "AWS_REGION=eu-west-2"
> terraform apply-var "AWS_REGION=eu-west-2"
