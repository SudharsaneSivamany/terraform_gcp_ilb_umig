
provider "google" {

  project = var.project
  region  = var.region
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  subnetwork           = var.subnetwork
  service_account      = null
  machine_type         = var.instance_tpl_spec.machine_type
  startup_script       = var.instance_tpl_spec.startup_script
  source_image_project = var.instance_tpl_spec.source_image_project
  source_image         = var.instance_tpl_spec.source_image
  tags                 = var.instance_tpl_spec.tags
}

module "umig" {
  source            = "terraform-google-modules/vm/google//modules/umig"
  project_id        = var.project
  subnetwork        = var.subnetwork
  num_instances     = var.umig_spec.instance_count
  hostname          = var.umig_spec.hostname
  instance_template = module.instance_template.self_link
  named_ports       = var.umig_spec.named_port
  region            = var.region
}

module "gce-ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  region       = var.region
  name         = var.ilb_spec.ilb_name
  ports        = var.ilb_spec.ports
  network      = var.network
  subnetwork   = var.subnetwork
  health_check = var.ilb_spec.health_check
  source_tags  = var.ilb_spec.source_tags
  target_tags  = var.ilb_spec.target_tags
  backends     = [for i in module.umig.self_links : { group = i, description = "", failover = false }]
}
