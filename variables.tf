variable "api_url" {
  description = "URL for proxmox host"
  type        = string
  sensitive   = true
}

variable "token_id" {
  description = "API token for terraform user login"
  type        = string
  sensitive   = true
}

variable "token_key" {
  description = "API key for terraform user login"
  type        = string
  sensitive   = true
}
