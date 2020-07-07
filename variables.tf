variable "regiones" {
    type    = list(string)
    default = [
        "us-ests-1",
        "us-west-2"
    ]
}

variable "az_prefix" {
    type    = list(string)
    default = [
        "a",
        "b",
        "c"
    ]
}