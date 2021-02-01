data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/code/"
  output_path = "/tmp/${var.function_name}.zip"
}

module "lambda_application" {
  source = "./lambda"

  depends_on = [
    null_resource.build,
    aws_lambda_layer_version.python_layer,
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]

  runtime              = var.runtime
  function_name        = var.function_name
  function_description = "Lambda application"
  handler              = "lambda.lambda_handler"
  lambda_role          = aws_iam_role.lambda_execution_role.arn
  layers               = [aws_lambda_layer_version.python_layer.arn]
  filename             = data.archive_file.zip.output_path
  source_code_hash     = data.archive_file.zip.output_base64sha256


  environment_variables = {
    ENV_REGION = var.aws_region
  }

  statement_id = "AllowExecutionFromAPIGateway"
  principal    = "apigateway.amazonaws.com"
}
