package spacelift

# Put your rules here.

deny[sprintf("%s should not be set to autodeploy", [stack.name])] {
    stack := input.third_party_metadata.custom.check.stacks[_]
    stack.autodeploy
}

sample { true }
