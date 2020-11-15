data "aws_caller_identity" "current" {}

data "aws_availability_zones" "azs" {
    filter {
        name = "region"
        values = [var.region]
    }
}