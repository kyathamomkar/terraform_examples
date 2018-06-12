
provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "terraform_instance" {
  ami           = "ami-922914f7"
  instance_type = "t2.micro"
  security_groups = ["allow_all"]
  tags {
    Name = "Hello"
  }
user_data = <<HEREDOC
#!/bin/bash
yum update -y
yum install -y httpd
service httpd start
chkconfig httpd on
echo "HEllo html" >> /var/www/html/index.html
HEREDOC
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}

output "ip" {
  value = "${aws_instance.terraform_instance.public_ip}"
}

