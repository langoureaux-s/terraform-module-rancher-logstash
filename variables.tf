variable "project_name" {
    description = "The project name (environment name)"
}
variable "stack_name" {
    description = "The name for the Elasticsearch stack"
}
variable "finish_upgrade" {
  description = "Automatically finish upgrade on Rancher when apply new plan"
}
variable "label_global_scheduling" {
  description = "The label to use when schedule this stack as global scheduling"
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
variable "input_rules" {
  description = "The input rules for Logstash"
  default = ""
}
variable "output_rules" {
  description = "The output rules for Logstash"
  default = ""
}
variable "filter_rules" {
  description = "The filter rules for Logstash"
  default = ""
}
variable "client_stack" {
  description = "The Elasticsearch stack name"
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
  default = "[\"5003:5003/tcp\"]"
}
variable "number_workers" {
  description = "The number of workers that logstash use"
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
  default = "1g"
}




