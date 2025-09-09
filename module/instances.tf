########################################
# EC2 INSTANCES AND NETWORK INTERFACES
########################################

# ENIs for web servers
resource "aws_network_interface" "web_server" {
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_network_interface" "web_server2" {
  subnet_id       = aws_subnet.dev_subnet.id
  security_groups = [aws_security_group.allow_web.id]
}

# EC2 Instance 1
resource "aws_instance" "instance1" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t3.micro"
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.generated_key.key_name

  primary_network_interface {
    network_interface_id = aws_network_interface.web_server.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your first web server1 > /var/www/html/index.html'
              EOF

  tags = {
    Name = "Myphp"
    env  = "Prod"
  }
}

# EC2 Instance 2
resource "aws_instance" "instance2" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t3.micro"
  availability_zone = "us-east-1b"
  key_name = aws_key_pair.generated_key.key_name

  primary_network_interface {
    network_interface_id = aws_network_interface.web_server2.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your first web server2 > /var/www/html/index.html'
              EOF

  tags = {
    Name = "Myphp"
    env  = "Prod"
  }
}
