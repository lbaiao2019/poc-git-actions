module "api_module" {
  source = "../api_gateway"

  application = "poc-git-actions"

  stage_name = "live"

  # Api Gateway Resource
  path_parts = ["app"]

  http_methods = ["POST"]

  request_parameters = [{
    "method.request.querystring.key" = "true"
    }]

  uri = [module.lambda_application.lambda_invoke_arn]
}