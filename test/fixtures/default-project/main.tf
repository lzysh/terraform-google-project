module "test" {
  source = "../../../"

  folder_id                   = var.folder_id
  prefix                      = var.prefix
  system                      = "default"
  env                         = var.env
  random_project_id           = true
  billing_id                  = var.billing_id
  cis_gcp_2_2_logging_bucket  = var.cis_gcp_2_2_logging_bucket
  cis_gcp_2_2_logging_project = var.cis_gcp_2_2_logging_project
}
