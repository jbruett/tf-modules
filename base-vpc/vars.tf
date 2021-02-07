locals {
    base_tags = {
        project = lower(var.project_name)
    }
    project_name = lower(var.project_name)
}

variable region {
    type = string
    default = "us-east-1"
}

variable vpc_cidr_block {
    type = string
    condition = can(regex("^(10(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){3}|((172.(1[6-9]|2[0-9]|3[01]))|192.168)(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){2})/20$", var.vpc_cidr))
    error_message = "The VPC cidr requires a valid RFC 1918 /20 cidr block."

}

variable public_cidr_blocks {
    type = list(string)
    condition = alltrue(for pcb in var.public_cidr_blocks : regex("^(10(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){3}|((172.(1[6-9]|2[0-9]|3[01]))|192.168)(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){2})/[21..28]$", pcb))
    error_message = "Each public cidr block requires a valid RFC 1918 /"
}

variable private_cidr_blocks {
    type = list(string)
    condition = alltrue(for pcb in var.public_cidr_blocks : regex("^(10(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){3}|((172.(1[6-9]|2[0-9]|3[01]))|192.168)(.(25[0-5]|2[0-4][0-9]|1[0-9]{1,2}|[0-9]{1,2})){2})/[21..28]$", pcb))
    error_message = "Each public cidr block requires a valid RFC 1918 /"

}

variable home_ip {
    type = string
}