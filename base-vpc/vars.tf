locals {
    base_tags = {
        project = lower(var.project_name)
    }
    project_name = lower(var.project_name)
}

variable region {
    type = string
}

variable vpc_cidr_block {
    type = string
}

variable public_cidr_blocks {
    type = list(string)
}

variable private_cidr_blocks {
    type = list(string)
}

variable home_ip {
    type = string
}