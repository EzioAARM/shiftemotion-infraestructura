#VPC para los recursos
resource "aws_vpc" "ShiftEmotionVPC" {
    cidr_block      = "10.0.0.0/16"
}

#subnet publica
resource "aws_subnet" "public" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
    cidr_block      = "10.0.1.0/24"
}

#subnet privada
resource "aws_subnet" "private" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
    cidr_block      = "10.0.2.0/24"
}

#internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
}

#route table
resource "aws_route_table" "route_table" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.gateway.id
    }
}

#asociación de route table y subnet
resource "aws_route_table_association" "public_subnet" {
    subnet_id       = aws_subnet.public.id
    route_table_id  = aws_route_table.route_table.id
}