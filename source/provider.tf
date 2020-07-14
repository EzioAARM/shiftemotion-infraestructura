provider "aws" {
    region  = "us-west-2"
}

variable "zonesOregon" {
    type    = list
    default = [
        "us-west-2a",
        "us-west-2b",
        "us-west-2c"
    ]
}

provider "aws" {
    alias   = "us-east-1"
    region  = "us-east-1"
}

variable "zonesVirginia" {
    type    = list
    default = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c"
    ]
}