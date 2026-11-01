output "instance_id" {
  value       = aws_instance.web-ec2.id
  description = "ec2 id"

}

output "ec2_public_ip" {
  value       = aws_instance.web-ec2.public_ip
  description = "ec2 pubic ip"

}

output "website_url" {
  value       = "http://${aws_instance.web-ec2.public_ip}"
  description = "full web link of ec2"

}

output "security_group_id" {
  value       = aws_security_group.web-sg.id
  description = "security group id"

}
