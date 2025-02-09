output "security_group_id" {
    description = "AWS security group id"
    value = aws_security_group.my-sg.id
}