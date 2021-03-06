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


locals {
  input_rules_name        = "${split(",", upper(join(",", var.input_rules_name)))}"
  input_rules             = "${split("<split>", indent(2, join("<split>", var.input_rules)))}"
  input_rules_computed    = "${indent(6, join("\n", formatlist("LS_RULE_INPUT_%s: |\n  %s", local.input_rules_name, local.input_rules)))}"
  filter_rules_name       = "${split(",", upper(join(",", var.filter_rules_name)))}"
  filter_rules            = "${split("<split>", indent(2, join("<split>", var.filter_rules)))}"
  filter_rules_computed   = "${indent(6, join("\n", formatlist("LS_RULE_FILTER_%s: |\n  %s", local.filter_rules_name, local.filter_rules)))}"
  output_rules_name       = "${split(",", upper(join(",", var.output_rules_name)))}"
  output_rules            = "${split("<split>", indent(2, join("<split>", var.output_rules)))}"
  output_rules_computed   = "${indent(6, join("\n", formatlist("LS_RULE_OUTPUT_%s: |\n  %s", local.output_rules_name, local.output_rules)))}"
  mem_limit               = "${var.container_memory != "" ? "mem_limit: ${var.container_memory}" : ""}"
  external_links          = "${indent(6, join("\n", formatlist("- %s", var.external_links)))}"
  filebeat_crt            = "${var.filebeat_certificate != "" ? "LS_CERT_FILEBEATCRT_NAME: filebeat.crt ${indent(6, "\nLS_CERT_FILEBEATCRT_CONTEND")}: | ${indent(8, "\n${var.filebeat_certificate}")}" : "" }"
  filebeat_key            = "${var.filebeat_key != "" ? "LS_CERT_FILEBEATKEY_NAME: filebeat.key ${indent(6, "\nLS_CERT_FILEBEATKEY_CONTEND")}: | ${indent(8, "\n${var.filebeat_key}")}" : "" }"
  ports                   = "${length(var.ports) > 0 ? "ports: ${indent(6, "\n${join("\n", formatlist("- %s", var.ports))}")}" : ""}"
  scale                   = "${var.scale != "" ? "scale: ${var.scale}" : ""}"
  volume_section          = "${var.docker_volume == "true" ? "volumes:\n  ${var.data_path}:\n    driver: ${var.storage_driver}\n    external: true" : ""}"
}


# Logstash without driver
data "template_file" "docker_compose_logstash" {
  template = "${file("${path.module}/rancher/logstash/docker-compose.yml")}"
  count = "${var.deploy_logstash_driver != "true" ? 1 : 0}"

  vars {
    ls_image                  = "${var.image_name}"
    ls_version                = "${var.image_version}"
    mem_limit                 = "${local.mem_limit}"
    cpu_shares                = "${var.cpu_shares}"
    external_links            = "${local.external_links}"
    data_path                 = "${var.data_path}"
    jvm_memory                = "${var.jvm_memory}"
    number_workers            = "${var.number_workers}"
    enable_monitoring         = "${var.enable_monitoring}"
    logstash_system_password  = "${var.logstash_system_password}"
    input_rules               = "${local.input_rules_computed}"
    output_rules              = "${local.output_rules_computed}"
    filter_rules              = "${local.filter_rules_computed}"
    filebeat_crt              = "${local.filebeat_crt}"
    filebeat_key              = "${local.filebeat_key}"
    label_scheduling          = "${var.label_scheduling}"
    global_scheduling         = "${var.global_scheduling}"
    ports                     = "${local.ports}"
    queue_type                = "${var.queue_type}"
    queue_max_bytes           = "${var.queue_max_bytes}"
    commit_id                 = "${var.commit_id}"
    volume_section            = "${local.volume_section}"
  }
}
data "template_file" "rancher_compose_logstash" {
  template = "${file("${path.module}/rancher/logstash/rancher-compose.yml")}"
  count = "${var.deploy_logstash_driver != "true" ? 1 : 0}"

  vars {
    scale                   = "${local.scale}"
  }
}
resource "rancher_stack" "this_logstash" {
  count = "${var.deploy_logstash_driver != "true" ? 1 : 0}"
  
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
  template = "${file("${path.module}/rancher/logstash-driver/docker-compose.yml")}"
  count = "${var.deploy_logstash_driver == "true" ? 1 : 0}"

  vars {
    ls_image                  = "${var.image_name}"
    ls_version                = "${var.image_version}"
    mem_limit                 = "${local.mem_limit}"
    cpu_shares                = "${var.cpu_shares}"
    external_links            = "${local.external_links}"
    data_path                 = "${var.data_path}"
    jvm_memory                = "${var.jvm_memory}"
    number_workers            = "${var.number_workers}"
    enable_monitoring         = "${var.enable_monitoring}"
    logstash_system_password  = "${var.logstash_system_password}"
    input_rules               = "${local.input_rules_computed}"
    output_rules              = "${local.output_rules_computed}"
    filter_rules              = "${local.filter_rules_computed}"
    filebeat_crt              = "${local.filebeat_crt}"
    filebeat_key              = "${local.filebeat_key}"
    label_scheduling          = "${var.label_scheduling}"
    global_scheduling         = "${var.global_scheduling}"
    ports                     = "${local.ports}"
    queue_type                = "${var.queue_type}"
    queue_max_bytes           = "${var.queue_max_bytes}"
    commit_id                 = "${var.commit_id}"
    logstash_driver_image     = "${var.logstash_driver_image}"
    logstash_driver_version   = "${var.logstash_driver_version}"
    volume_section            = "${local.volume_section}"
  }
}
data "template_file" "rancher_compose_logstash_driver" {
  template = "${file("${path.module}/rancher/logstash-driver/rancher-compose.yml")}"
  count = "${var.deploy_logstash_driver == "true" ? 1 : 0}"

  vars {
    scale                   = "${local.scale}"
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