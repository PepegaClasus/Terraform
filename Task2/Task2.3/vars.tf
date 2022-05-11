variable "domain_name" {
    default = "bucketforcloudfront"
}

variable "bucket_name"{
    default = "bucketforcloudfront"
}

variable "env" {
  description = "Depolyment environment"
  default     = "dev"
}

variable "repository_branch" {
  description = "Repository branch to connect to"
  default     = "main"
}

variable "repository_name" {
  description = "GitHub repository name"
  default     = "PepegaClasus/Htmlpage"
}

variable "github_connection"{
  description = "Github connection"
  default = "arn:aws:codestar-connections:us-east-1:571653323309:connection/55fe29b0-12a7-41b5-a311-ce15d87a40ef"
}