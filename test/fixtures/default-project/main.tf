module "test" {
  source = "../../../"

  folder_id         = var.folder_id
  prefix            = var.prefix
  system            = "default"
  env               = var.env
  random_project_id = true
  billing_id        = var.billing_id
}
