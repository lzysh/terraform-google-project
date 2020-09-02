locals {
  base_project_id = "${var.prefix}-${var.system}-${var.env}"
  project_id = var.random_project_id ? format(
    "%s-%s-%s-%s",
    var.prefix,
    var.system,
    random_id.random[0].hex,
    var.env,
  ) : local.base_project_id
}

# Random ID Resource
# https://www.terraform.io/docs/providers/random/r/id.html

resource "random_id" "random" {
  count = var.random_project_id ? 1 : 0
  prefix      = "tf"
  byte_length = "3"
}

# Project Resource
# https://www.terraform.io/docs/providers/google/r/google_project.html

resource "google_project" "project" {
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

resource "google_compute_project_metadata" "metadata" {
  project = google_project.project.project_id
  metadata = {
    enable-oslogin = true
  }
}
