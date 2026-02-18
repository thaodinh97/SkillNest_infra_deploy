variable "project_name" {
  description = "Project name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "backend_desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 1
}

variable "backend_cpu" {
  type    = number
  default = 512
}

variable "backend_memory" {
  type    = number
  default = 1024
}
