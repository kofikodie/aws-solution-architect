resource "aws_lambda_function" "lambda_func" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  depends_on    = [var.attach_iam_policy_to_iam_role]
}
