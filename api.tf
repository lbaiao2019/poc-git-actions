module "api_module" {
  source = "./api_gateway"

  application = "poc-git-actions"

  stage_name = "live"

  # Api Gateway Resource
  path_parts = ["app"]

  http_methods = ["GET"]

  request_parameters = []

  uri = [module.lambda_application.lambda_invoke_arn]
}