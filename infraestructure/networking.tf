#VPC para los recursos
resource "aws_vpc" "ShiftEmotionVPC" {
    cidr_block      = "10.0.0.0/16"
    tags            = {
        Name        = "ShiftEmotionVPC"
    }
}

#subnets publicas
resource "aws_subnet" "public" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
    cidr_block      = "10.0.1.0/24"
}

resource "aws_subnet" "public2" {
    vpc_id          = aws_vpc.ShiftEmotionVPC.id
    cidr_block      = "10.0.3.0/24"
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

#asociación de route table y subnet publica
resource "aws_route_table_association" "public_subnet" {
    subnet_id       = aws_subnet.public.id
    route_table_id  = aws_route_table.route_table.id
}

resource "aws_route_table_association" "public2_subnet" {
    subnet_id       = aws_subnet.public2.id 
    route_table_id  = aws_route_table.route_table.id
}

resource "aws_security_group" "sg_global" {
    name            = "general_security_group"
    description     = "Security group para ShiftEmotion"
    vpc_id          = aws_vpc.ShiftEmotionVPC.id

    ingress {
        description = "Conexiones desde la VPC"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [
            aws_vpc.ShiftEmotionVPC.cidr_block
        ]
    }

    egress {
        description = "Salida a cualquier lugar"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
}