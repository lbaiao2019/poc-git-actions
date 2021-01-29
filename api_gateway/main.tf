# API Gateway
resource "aws_api_gateway_rest_api" "default" {
  name = var.application
}

resource "aws_api_gateway_resource" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.default.id
  path_part   = element(var.path_parts, count.index)
}


resource "aws_api_gateway_method" "default" {
  count              = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  rest_api_id        = aws_api_gateway_rest_api.default.id
  resource_id        = aws_api_gateway_resource.default.*.id[count.index]
  http_method        = length(var.http_methods) > 0 ? element(var.http_methods, count.index) : "POST"
  authorization      = length(var.authorizations) > 0 ? element(var.authorizations, count.index) : "NONE"
  request_parameters = length(var.request_parameters) > 0 ? element(var.request_parameters, count.index) : {}
  #api_key_required   = true

}

resource "aws_api_gateway_integration" "default" {
  count                   = length(aws_api_gateway_method.default.*.id)
  rest_api_id             = aws_api_gateway_rest_api.default.*.id[0]
  resource_id             = aws_api_gateway_resource.default.*.id[count.index]
  http_method             = aws_api_gateway_method.default.*.http_method[count.index]
  integration_http_method = length(var.integration_http_methods) > 0 ? element(var.integration_http_methods, count.index) : "POST"
  type                    = length(var.integration_types) > 0 ? element(var.integration_types, count.index) : "AWS_PROXY"
  uri                     = length(var.uri) > 0 ? element(var.uri, count.index) : ""
}


resource "aws_api_gateway_deployment" "default" {
  rest_api_id       = aws_api_gateway_rest_api.default.id
  stage_name        = var.stage_name
  stage_description = "Deployed at ${timestamp()}"

  depends_on = [aws_api_gateway_method.default, aws_api_gateway_integration.default]
}
resource "aws_api_gateway_usage_plan" "default" {
  name = "${var.application}_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.default.id
    stage  = aws_api_gateway_deployment.default.stage_name
  }
}

resource "aws_api_gateway_api_key" "default" {
  name = "${var.application}_key"
}

resource "aws_api_gateway_usage_plan_key" "default" {
  key_id        = aws_api_gateway_api_key.default.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default.id
}