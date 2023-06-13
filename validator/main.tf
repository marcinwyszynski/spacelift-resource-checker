terraform {
  required_providers {
    spacelift = { source = "spacelift-io/spacelift" }
  }
}

provider "spacelift" {}

data "spacelift_stacks" "stacks" {}
