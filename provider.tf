# Configure the AWS Provider
provider "aws" {
    region  = "us-east-1"
}

provider "aws" {
    alias = "us-west-2"
    region = "us-west-2"
}
