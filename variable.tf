variable "project" {
  type        = string
  description = "Enther the project id"
}

variable "region" {
  type        = string
  description = "Enter the region"
  default     = "us-central1"
}



variable "umig_spec" {
  type = object({
    hostname       = string
    instance_count = number
    named_port = list(object({
      name = string
      port = string
    }))
  })
}

variable "instance_tpl_spec" {
  type = object({
    machine_type         = string
    startup_script       = string
    source_image_project = string
    source_image         = string
    tags                 = list(string)
  })
}

variable "network" {
  type        = string
  description = "Enter the network"
}

variable "subnetwork" {
  type        = string
  description = "Enter the subnetwork name"
}

variable "ilb_spec" {
  type = object({
    ilb_name    = string
    ports       = list(string)
    source_tags = list(string)
    target_tags = list(string)
    health_check = object({
      type                = string
      check_interval_sec  = number
      healthy_threshold   = number
      timeout_sec         = number
      unhealthy_threshold = number
      response            = string
      proxy_header        = string
      port                = number
      port_name           = string
      request             = string
      request_path        = string
      host                = string
      enable_log          = bool
    })
  })
}


