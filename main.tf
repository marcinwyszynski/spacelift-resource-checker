terraform {
  required_providers {
    spacelift = { source = "spacelift-io/spacelift" }
  }
}

provider "spacelift" {}

resource "spacelift_stack" "validator" {
  name        = "Spacelift resource validator"
  description = "Continuous validation for Spacelift resources"
  
  administrative = true
  project_root   = "validator"
  after_plan     = ["terraform show -json spacelift.plan | jq -c '.prior_state.values.root_module.resources[0].values' > check.custom.spacelift.json"]

  raw_git {
     namespace = "marcinwyszynski"
     url = "https://github.com/marcinwyszynski/spacelift-resource-checker.git"
  }
  
  repository = "spacelift-resource-checker"
}
