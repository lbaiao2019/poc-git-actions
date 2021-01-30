variable "runtime" {
  type    = string
  default = "python3.7"
}

variable "function_name" {
  type = string
}

variable "function_description" {
  type = string
}

variable "handler" {
  type = string
}

variable "lambda_role" {
}

variable "memory_size" {
  type    = string
  default = "1024"
}

variable "timeout" {
  type    = string
  default = "120"
}

variable "filename" {
}

variable "source_code_hash" {
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "statement_id" {
  default = null
}

variable "action" {
  type    = string
  default = "lambda:InvokeFunction"
}

variable "principal" {
  default = null
}

variable "source_arn" {
  type    = string
  default = ""
}

variable "vpc_subnet_ids" {
  default = null
}

variable "vpc_security_group_ids" {
  default = null
}