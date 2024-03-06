output "policy_attachment" {
  value = aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role
}

output "role_arn" {
  value = aws_iam_role.lambda_role.arn
}
