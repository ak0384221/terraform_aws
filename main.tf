data "aws_vpc" "default" {
  default = true
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

}

data "aws_key_pair" "existing" {

  key_name           = "yourstore-backend"
  include_public_key = true

}


# security-group
resource "aws_security_group" "web-sg" {

  name        = "${var.name}-sg"
  description = "Allow ssh from anywhere and http fron anywhere"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.name}-sg"
  }

}


resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  description       = "SSH from anywhere"


}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

}


resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}



# EC2

resource "aws_instance" "web-ec2" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.existing.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>Hello from $(hostname -f) </h1>" > /var/www/html/index.html
    EOF

  user_data_replace_on_change = true
  tags = {
    Name = "${var.name}-instance"
  }


}
