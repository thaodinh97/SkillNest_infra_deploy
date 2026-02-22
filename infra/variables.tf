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

variable "db_url" {
  description = "Database Connection URL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database Username"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT Secret Key"
  type        = string
  sensitive   = true
}

variable "cors_allowed_origins" {
  description = "CORS Allowed Origins"
  type        = string
}

variable "cloudinary_cloud_name" {
  description = "Cloudinary Cloud Name"
  type        = string
  sensitive   = true
}

variable "cloudinary_api_key" {
  description = "Cloudinary API Key"
  type        = string
  sensitive   = true
}

variable "cloudinary_api_secret" {
  description = "Cloudinary API Secret"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Official domain name"
  type        = string
  default     = "skillnestedu.id.vn"
}

variable "api_domain" {
  description = "Subdomain for Backend API"
  type        = string
  default     = "api.skillnest.id.vn"
}


###