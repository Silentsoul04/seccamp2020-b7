provider "google" {
  project = var.project
}

data "google_project" "project" {
}

# dns

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
}

resource "google_dns_managed_zone" "default" {
  name     = "default"
  dns_name = "${var.domain_base}."

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "name-for-admin-console" {
  name         = "${var.domain_base}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default
  rrdatas      = [module.gke.ingress_ip]

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "name-for-admin-console" {
  name         = "*.${var.domain_base}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default
  rrdatas      = [module.gke.ingress_ip]

  depends_on = [
    google_project_service.dns,
  ]
}

# gke

module "gke" {
  project = var.project
  source  = "./modules/gke"
}
