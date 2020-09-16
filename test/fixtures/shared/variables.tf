variable "env" {
  type    = string
  default = "sb"
}

variable "prefix" {
  type    = string
  default = "ops"
}

variable "folder_id" {
  type    = string
  default = "739059474420"
}

variable "billing_id" {
  type = string
}

variable "cis_gcp_2_2_logging_bucket" {
  type    = string
  default = "cis-gcp-2-2-logging-sink"
}

variable "cis_gcp_2_2_logging_project" {
  type    = string
  default = "ops-tools-prod"
}
