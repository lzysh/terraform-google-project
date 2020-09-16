locals {
  base_project_id = "${var.prefix}-${var.system}-${var.env}"
  project_id = var.random_project_id ? format(
    "%s-%s-%s-%s",
    var.prefix,
    var.system,
    random_id.this[0].hex,
    var.env,
  ) : local.base_project_id
}

# Random ID Resource
# https://www.terraform.io/docs/providers/random/r/id.html

resource "random_id" "this" {
  count       = var.random_project_id ? 1 : 0
  prefix      = "tf"
  byte_length = "3"
}

# Project Resource
# https://www.terraform.io/docs/providers/google/r/google_project.html

resource "google_project" "this" {
  name                = local.project_id
  project_id          = local.project_id
  billing_account     = var.billing_id
  folder_id           = "folders/${var.folder_id}"
  auto_create_network = false
  labels = {
    cost-center = var.cost_center
  }
}

# Project Metadata Resource
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html

resource "google_compute_project_metadata" "this" {
  project = google_project.this.project_id
  metadata = {
    enable-oslogin = true
  }
}

# Project Logging Sink
# https://www.terraform.io/docs/providers/google/r/logging_project_sink.html

resource "google_logging_project_sink" "cis_gcp_2_2_logging" {
  name        = "cis-gcp-2.2-logging-sink"
  project     = google_project.this.project_id
  destination = "storage.googleapis.com/${var.cis_gcp_2_2_logging_bucket}"

  unique_writer_identity = true
}

resource "google_project_iam_binding" "cis_gcp_2_2_log_writer" {
  project = var.cis_gcp_2_2_logging_project
  role    = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.cis_gcp_2_2_logging.writer_identity,
  ]
}
