output "instance_ami" {
  value = aws_instance.blog.ami
}

output "instance_arn" {
  value = aws_instance.blog.arn
}

output "public dns" {
  value = aws_instance.blog.public_dns
}
