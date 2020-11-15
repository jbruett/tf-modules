resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(map("Name","${local.project_name}"),local.base_tags)
}

resource "aws_subnet" "public_0" {
    availability_zone_id = sort(data.aws_availability_zones.availability_zone_id)[0]
    cidr_block = var.public_cidr_blocks[0]
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc.id
    tags = merge(map("Name","${local.project_name}-public-0"),local.base_tags)
}

resource "aws_subnet" "public_1" {
    availability_zone_id = sort(data.aws_availability_zones.availability_zone_id)[1]
    cidr_block = var.public_cidr_blocks[1]
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc.id
    tags = merge(map("Name","${local.project_name}-public-1"),local.base_tags)
}

resource "aws_subnet" "private_0" {
    availability_zone_id = sort(data.aws_availability_zones.availability_zone_id)[0]
    cidr_block = var.private_cidr_blocks[0]
    map_public_ip_on_launch = false
    vpc_id = aws_vpc.vpc.id
    tags = merge(map("Name","${local.project_name}-private-0"),local.base_tags)
}

resource "aws_subnet" "private_1" {
    availability_zone_id = sort(data.aws_availability_zones.availability_zone_id)[1]
    cidr_block = var.private_cidr_blocks[1]
    map_public_ip_on_launch = false
    vpc_id = aws_vpc.vpc.id
    tags = merge(map("Name","${local.project_name}-private-1"),local.base_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(map("Name",local.project_name),local.base_tags)
}

resource "aws_route_table" "default_public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(map("Name","${local.project_name}-public-rt"),local.base_tags)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default_vpc.id
  }
}

resource "aws_security_group" "personal_inbound" {
    name = "${local.project_name}-inbound"
    description = "[tf] access from home ip"
    vpc_id = aws_vpc.vpc.id
    tags = merge(map("Name","${local.project_name}-inbound"),local.base_tags)

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "[tf] ssh"
      cidr_blocks = ["${var.home_ip}/32"]
    }

    ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      description = "[tf] rdp"
      cidr_blocks = ["${var.home_ip}/32"]
    }
}