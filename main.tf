terraform {
  required_providers {
    spacelift = { source = "spacelift-io/spacelift" }
  }
}

provider "spacelift" {}

data "spacelift_current_stack" "this" {}

data "spacelift_stack" "this" {
  stack_id = data.spacelift_current_stack.this.id
}

resource "spacelift_stack" "validator" {
  name        = "Spacelift resource validator"
  description = "Continuous validation for Spacelift resources"
  
  administrative = true
  project_root   = "validator"
  space_id       = data.spacelift_stack.this.space_id

  after_plan = [
    "terraform show -json spacelift.plan | jq -c '.prior_state.values.root_module.resources[0].values' > check.custom.spacelift.json",
  ]

  raw_git {
     namespace = data.spacelift_stack.this.raw_git[0].namespace
     url = data.spacelift_stack.this.raw_git[0].url
  }
  
  repository = data.spacelift_stack.this.repository
  branch     = data.spacelift_stack.this.branch
}

resource "spacelift_policy" "validator" {
  name     = "Spacelift resource validator"
  space_id = data.spacelift_stack.this.space_id
  body     = file("${path.module}/plan_policy.rego")
  type     = "PLAN"
}

resource "spacelift_policy_attachment" "no-weekend-deploys" {
  policy_id = spacelift_policy.validator.id
  stack_id  = spacelift_stack.validator.id
}
