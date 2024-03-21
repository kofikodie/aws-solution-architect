resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy" "policy" {
  name   = var.policy_name
  role   = aws_iam_role.role.name
  policy = var.policy_document
}
