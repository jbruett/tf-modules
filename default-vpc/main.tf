resource "aws_default_vpc" "default" {
    tags = {
      Name = "default"
    }
}

resource "aws_default_subnet" "public" {
  for_each = toset(var.public_azs)
    availability_zone = each.key
    tags = {
      Name = "default-public-${substr(each.key,length(each.key)-2,2)}"
    }
    
}

resource "aws_default_subnet" "private" {
    for_each = toset(var.private_azs)
    availability_zone = each.key
    tags = {
      Name = "default-public-${substr(each.key,length(each.key)-2,2)}"
    }
}

resource "aws_default_route_table" "default" {
    default_route_table_id = aws_default_vpc.default.default_route_table_id
    tags = {
      Name = "default"
    }
}

# resource "aws_default_network_acl" "default" {
#   default_network_acl_id = aws_default_vpc.default.default_network_acl_id

#   subnet_ids = toset(concat(aws_default_subnet.private[*].id,aws_default_subnet.public[*].id))

#   ingress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = aws_default_vpc.default.cidr_block
#     from_port  = 0
#     to_port    = 0
#   }

#   egress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   tags = {
#     Name = "default"
#   }
# }

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default"
  }
}

resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    Name = "default"
  }
}

resource "aws_ebs_encryption_by_default" "default" {
  enabled = true
}

output "private_subnet" {
  value = aws_default_subnet.private[*]
}

output "public_subnet" {
  value = aws_default_subnet.public[*]
}