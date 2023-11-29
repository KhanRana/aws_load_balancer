# create ec2 instances 
resource "aws_instance" "smart_home" {
  count         = length(var.subnet_id)
  ami           = var.AMI
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[count.index]
  key_name      = var.key_pair

  associate_public_ip_address = true

  vpc_security_group_ids = var.security_groups
  tags = {
    Name = var.ec2_name[count.index]
  }
}
