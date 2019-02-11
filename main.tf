terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "consul" {}
}

# Template provider
provider "template" {
  version = "~> 1.0"
}

# Get the project data
data "rancher_environment" "project" {
  name = "${var.project_name}"
}


# Logstash without driver
data "template_file" "docker_compose_logstash" {
  template = "${file("${path.module}/rancher/logstash/docker-compose.yml")}"

  vars {
    ls_image                  = "${var.image_name}"
    ls_version                = "${var.image_version}"
    mem_limit                 = "${var.container_memory != "" ? "mem_limit: ${var.container_memory}" : ""}"
    cpu_shares                = "${var.cpu_shares}"
    external_links            = "${indent(6, join("\n", formatlist("- %s", var.external_links)))}"
    data_path                 = "${var.data_path}"
    jvm_memory                = "${var.jvm_memory}"
    number_workers            = "${var.number_workers}"
    enable_monitoring         = "${var.enable_monitoring}"
    logstash_system_password  = "${var.logstash_system_password}"
    input_rules               = "${indent(8, var.input_rules)}"
    output_rules              = "${indent(8, var.output_rules)}"
    filter_rules              = "${indent(8, var.filter_rules)}"
    filebeat_crt              = "${indent(8, var.filebeat_certificate)}"
    filebeat_key              = "${indent(8, var.filebeat_key)}"
    label_scheduling          = "${var.label_scheduling}"
    global_scheduling         = "${var.global_scheduling}"
    ports                     = "${indent(6, join("\n", formatlist("- %s", var.ports)))}"
    queue_type                = "${var.queue_type}"
    queue_max_bytes           = "${var.queue_max_bytes}"
    commit_id                 = "${var.commit_id}"
  }
}
data "template_file" "rancher_compose_logstash" {
  template = "${file("${path.module}/rancher/logstash/rancher-compose.yml")}"

  vars {
    scale                   = "${var.scale != "" ? "scale: ${var.scale}" : ""}"
    scale_driver            = "${var.deploy_logstash_driver != "true" ? "scale: 0" : ""}"
  }
}
resource "rancher_stack" "this_logstash" {
  name            = "${var.stack_name}"
  description     = "Logstash - Processing events"
  environment_id  = "${data.rancher_environment.project.id}"
  scope           = "user"
  start_on_create = true
  finish_upgrade  = "${var.finish_upgrade}"
  docker_compose  = "${data.template_file.docker_compose_logstash.rendered}"
  rancher_compose = "${data.template_file.rancher_compose_logstash.rendered}"
}



# Logstash with driver
data "template_file" "docker_compose_logstash_driver" {
  template = "${file("${path.module}/rancher/logstash/docker-compose.yml")}"
  count = "${var.deploy_logstash_driver == "true" ? 1 : 0}"

  vars {
    ls_image                  = "${var.image_name}"
    ls_version                = "${var.image_version}"
    mem_limit                 = "${var.container_memory != "" ? "mem_limit: ${var.container_memory}" : ""}"
    cpu_shares                = "${var.cpu_shares}"
    external_links            = "${indent(6, join("\n", formatlist("- %s", var.external_links)))}"
    data_path                 = "${var.data_path}"
    jvm_memory                = "${var.jvm_memory}"
    number_workers            = "${var.number_workers}"
    enable_monitoring         = "${var.enable_monitoring}"
    logstash_system_password  = "${var.logstash_system_password}"
    input_rules               = "${indent(8, var.input_rules)}"
    output_rules              = "${indent(8, var.output_rules)}"
    filter_rules              = "${indent(8, var.filter_rules)}"
    filebeat_crt              = "${indent(8, var.filebeat_certificate)}"
    filebeat_key              = "${indent(8, var.filebeat_key)}"
    label_scheduling          = "${var.label_scheduling}"
    global_scheduling         = "${var.global_scheduling}"
    ports                     = "${indent(6, join("\n", formatlist("- %s", var.ports)))}"
    queue_type                = "${var.queue_type}"
    queue_max_bytes           = "${var.queue_max_bytes}"
    commit_id                 = "${var.commit_id}"
    logstash_driver_image     = "${var.logstash_driver_image}"
    logstash_driver_version   = "${var.logstash_driver_version}"
  }
}
data "template_file" "rancher_compose_logstash_driver" {
  template = "${file("${path.module}/rancher/logstash/rancher-compose.yml")}"
  count = "${var.deploy_logstash_driver == "true" ? 1 : 0}"

  vars {
    scale                   = "${var.scale != "" ? "scale: ${var.scale}" : ""}"
  }
}
resource "rancher_stack" "this_logstash_driver" {
  count = "${var.deploy_logstash_driver == "true" ? 1 : 0}"
  
  name            = "${var.stack_name}"
  description     = "Logstash - Processing events"
  environment_id  = "${data.rancher_environment.project.id}"
  scope           = "user"
  start_on_create = true
  finish_upgrade  = "${var.finish_upgrade}"
  docker_compose  = "${data.template_file.docker_compose_logstash_driver.rendered}"
  rancher_compose = "${data.template_file.rancher_compose_logstash_driver.rendered}"
}