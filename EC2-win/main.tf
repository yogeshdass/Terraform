provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "winsvr" {
  ami = "ami-050202fb72f001b47"
  count = 1
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "jnks"
  get_password_data = true
  subnet_id = "subnet-0435cb40367fa1b04"
  instance_initiated_shutdown_behavior = "terminate"
}

output "passwd" {
  value = "${rsadecrypt(aws_instance.winsvr.password_data,file("/jnks.pem"))}"
}




