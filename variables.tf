variable "project_name" {
    description = "The project name (environment name)"
}
variable "stack_name" {
    description = "The name for the Elasticsearch stack"
}
variable "finish_upgrade" {
  description = "Automatically finish upgrade on Rancher when apply new plan"
}
variable "scale" {
  description = "Set the number of instance you should.Don't use it if you should global_scheduling as true"
  default = ""
}
variable "label_scheduling" {
  description = "The label to use when schedule this stack"
  default = ""
}
variable "global_scheduling" {
  description = "Set to true if you should to deploy on all node that match label_scheduling"
  default     = "true"
}
variable "commit_id" {
  description = "The commit id that build image. It's usefull to force pull new image when use always the same tag"
  default = ""
}


variable "image_version" {
  description = "The image version of Logstash to use"
  default = "6.5.4-2"
}
variable "image_name" {
  description = "The image name to use"
  default = "harbor.hm.dm.ad/logmanagement/logstash"
}
variable "data_path" {
  description = "The path where to store logstash data (queue)"
}
variable "jvm_memory" {
  description = "The memory that the logstash JVM can consume"
}
variable "enable_monitoring" {
  description = "Enable/disable the logstash monitoring"
}
variable "logstash_system_password" {
  description = "The logstash_system password"
}
variable "input_rules_name" {
  description = "The input rules name for Logstash"
  type = "list"
  default = []
}
variable "input_rules" {
  description = "The input rules for Logstash"
  type = "list"
  default = []
}
variable "output_rules_name" {
  description = "The output rules name for Logstash"
  type = "list"
  default = []
}
variable "output_rules" {
  description = "The output rules for Logstash"
  type = "list"
  default = []
}
variable "filter_rules_name" {
  description = "The filter rules name for Logstash"
  type = "list"
  default = []
}
variable "filter_rules" {
  description = "The filter rules for Logstash"
  type = "list"
  default = []
}
variable "external_links" {
  description = "List for external links"
  type = "list"
  default = []
}
variable "filebeat_certificate" {
  description = "The filebeat certificate contend"
  default = ""
}
variable "filebeat_key" {
  description = "The filebeat key contend"
  default = ""
}
variable "ports" {
  description = "the array of exposed port as flat list"
  type = "list"
  default = []
}
variable "number_workers" {
  description = "The number of workers that logstash use"
  default = ""
}

variable "container_memory" {
  description = "The maximum of memory that this container can consume"
}
variable "cpu_shares" {
  description = "The maximum of CPU usage that this container can consume"
  default = "1024"
}
variable "queue_type" {
  description = "Specify persisted to enable persistent queues. By default, persistent queues are disabled (default: queue.type: memory)"
  default = "memory"
}
variable "queue_max_bytes" {
  description = "The total capacity of the queue in number of bytes. The default is 1024mb (1gb). Make sure the capacity of your disk drive is greater than the value you specify here."
  default = "1gb"
}

variable "deploy_logstash_driver" {
  description = "Permit to deploy logstash driver container as sidekicks"
  default = "false"
}
variable "logstash_driver_image" {
  description = "The logstash driver image to use"
  default = "harbor.hm.dm.ad/logmanagement/logstash-driver"
}
variable "logstash_driver_version" {
  description = "Thes logstash driver version to use"
  default = "latest"
}