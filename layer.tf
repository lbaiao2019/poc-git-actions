resource "null_resource" "build" {
  provisioner "local-exec" {
    command    = "/bin/bash ${path.module}/layer/build.sh;"
    on_failure = fail
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "/tmp/${var.function_name}.zip"
}

resource "aws_lambda_layer_version" "python_layer" {
  depends_on          = [null_resource.build]
  layer_name          = var.function_name
  compatible_runtimes = [var.runtime]
  filename            = "/tmp/application_libs.zip"
  source_code_hash    = base64sha256("/tmp/application_libs.zip")
}

