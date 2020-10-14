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

# Project Service Resource
# https://www.terraform.io/docs/providers/google/r/google_project_service.html

resource "google_project_service" "this" {
  count = length(var.services)

  project = google_project.this.project_id
  service = element(var.services, count.index)

  disable_on_destroy = false
}

# Project Metadata Resource
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html

resource "google_compute_project_metadata" "this" {
  project = google_project.this.project_id

  metadata = {
    enable-oslogin = true
  }
}

# KeyRing Resource
# https://www.terraform.io/docs/providers/google/r/kms_key_ring.html

resource "google_kms_key_ring" "this" {
  name     = "default-keyring"
  project  = google_project.this.project_id
  location = "us-east4"

  depends_on = [google_project_service.this]
}

# KMS CryptoKey Resource
# https://www.terraform.io/docs/providers/google/r/kms_crypto_key.html

resource "google_kms_crypto_key" "cis_gcp_2_2" {
  name            = "cis-gcp-2-2-key-logging-sink"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "100000s"
}

# KMS Crypto Key IAM Policy Resource
# https://www.terraform.io/docs/providers/google/r/google_kms_crypto_key_iam.html

resource "google_kms_crypto_key_iam_member" "cis_gcp_2_2" {
  crypto_key_id = google_kms_crypto_key.cis_gcp_2_2.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${google_project.this.number}@gs-project-accounts.iam.gserviceaccount.com"
}

# Storage Bucket Resource
# https://www.terraform.io/docs/providers/google/r/storage_bucket.html

resource "google_storage_bucket" "cis_gcp_2_2" {
  name                        = "${google_project.this.project_id}-cis-gcp-2-2-logging-sink"
  project                     = google_project.this.project_id
  uniform_bucket_level_access = true
  location                    = "us-east4"

  encryption {
    default_kms_key_name = google_kms_crypto_key.cis_gcp_2_2.id
  }
}

# Project Logging Sink Resource
# https://www.terraform.io/docs/providers/google/r/logging_project_sink.html

resource "google_logging_project_sink" "cis_gcp_2_2_logging" {
  name                   = "cis-gcp-2.2-logging-sink"
  project                = google_project.this.project_id
  destination            = "storage.googleapis.com/${google_storage_bucket.cis_gcp_2_2.name}"
  unique_writer_identity = true
}

resource "google_project_iam_binding" "cis_gcp_2_2_log_writer" {
  project = google_project.this.project_id
  role    = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.cis_gcp_2_2_logging.writer_identity,
  ]
}
