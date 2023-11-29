# output the list of all instances ids
output "instance_id" {
  value = aws_instance.smart_home[*].id
}

# output the number of ec2 servers created 
output "no_app_ec2" {
  value = length(aws_instance.smart_home[*])
}
