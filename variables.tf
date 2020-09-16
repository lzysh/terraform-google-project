variable "billing_id" {
  description = "Billing ID for the project to use"
  type        = string
}

variable "cis_gcp_2_2_logging_bucket" {
  description = "Name of bucket for cis-gcp-2.2-logging all log entries"
  type        = string
  default     = ""
}

variable "cis_gcp_2_2_logging_project" {
  description = "Name of project for cis-gcp-2.2-logging all log entries bucket"
  type        = string
  default     = ""
}

variable "cost_center" {
  description = "Cost center to label the project."
  type        = string
  default     = "x123"
}

variable "env" {
  description = "This is the environment suffix for example: sb (Sandbox), acc (Acceptance), exp (Exploratory), uat (User Acceptance Testing), prod (Production)."
  type        = string
  default     = "sb"
}

variable "folder_id" {
  description = "Folder ID for the project to be created in."
  type        = string
}

variable "prefix" {
  description = "This is your team prefix for example: ops (operations)."
  type        = string
  default     = "test"
}

variable "random_project_id" {
  description = "Adds a random hex value with a prefix of tf to the `project_id`"
  type        = bool
  default     = true
}

variable "system" {
  description = "This should be a short name representing the system or part of the system you're building in the project for example: tools (for a set of tooling resources)."
  type        = string
  default     = "foobar"
}
