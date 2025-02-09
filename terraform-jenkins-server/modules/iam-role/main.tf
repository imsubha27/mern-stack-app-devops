resource "aws_iam_role" "ec2_admin" {
  name = "ec2-admin-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "admin_attach" {
  name       = "admin-attachment"
  roles      = [aws_iam_role.ec2_admin.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "role_name" {
  value = aws_iam_role.ec2_admin.name
}