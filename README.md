# Google Cloud Platform - Terraform Project Module ![Kitchen Tests](https://github.com/lzysh/terraform-google-project/workflows/Kitchen%20Tests/badge.svg)

Terraform module for a Google Cloud Platform project.

## Usage

```hcl
module "project" {
  source  = "git@github.com:lzysh/terraform-google-project.git?ref=v1.0.0"

  cost_center       = "x123"
  folder_id         = "1111111111111"
  prefix            = "test"
  system            = "tools"
  env               = "sb"
  billing_id        = var.billing_id
}
```

## Project Names

Project names include a prefix, some sort of description as well as
an environment in it for example:

```none
test-tools-tf6310f3-sb
```

> NOTE: The `tf6310f3` is a random string Terraform creates in an effort not to duplicate
project IDs. The reason we do this is because project IDs are gloabally unique also
when you delete a project it goes into a pending deletion state for 30 days where
you can't reuse the project ID. If you want to exclude this from your project name
you can use the variable: `random_project_id = false`
