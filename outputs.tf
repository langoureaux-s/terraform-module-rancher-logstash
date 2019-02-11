locals {
  stack_id    = "${compact(concat(coalescelist(rancher_stack.this_logstash.*.id, rancher_stack.this_logstash_driver.*.id), list("")))}"
  stack_name  = "${compact(concat(coalescelist(rancher_stack.this_logstash.*.name, rancher_stack.this_logstash_driver.*.name), list("")))}"
}


output "stack_id" {
  value = "${join("", local.stack_id)}"
}

output "stack_name" {
  value = "${join("", local.stack_name)}/logstash"
}