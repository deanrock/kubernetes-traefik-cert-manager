variable "prefix" {
  description = "Prefix resource names."
  type        = string
}

variable "region" {
  description = "DigitalOcean region."
  type        = string
  default     = "fra1"
}

variable "domain" {
  description = "Domain name."
  type        = string
}

variable "letsencrypt_email" {
  description = "Email provided to Lets Encrypt."
  type        = string
}
