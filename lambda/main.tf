resource "aws_lambda_function" "default" {

  runtime       = var.runtime
  function_name = var.function_name
  description   = var.function_description
  handler       = var.handler
  role          = var.lambda_role
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = var.filename
  source_code_hash = var.source_code_hash

  layers = var.layers

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "default" {
  count         = var.statement_id != null ? 1 : 0
  statement_id  = var.statement_id
  action        = var.action
  function_name = aws_lambda_function.default.arn
  principal     = var.principal
  source_arn    = var.source_arn
}