variable "aws_region" {
}

variable "envname" {
}

variable "accname" {
}

variable "function_name" {
  type    = string
  default = "poc-git-actions"
}

variable "runtime" {
  type    = string
  default = "python3.8"
}
