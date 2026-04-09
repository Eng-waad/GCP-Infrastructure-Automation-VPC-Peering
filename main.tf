# --- Google Cloud Platform: VPC Peering Infrastructure ---

provider "google" {
  # The project ID will be inherited from the environment or CLI
  region = "us-central1"
}

# 1. Frontend Network Configuration
resource "google_compute_network" "vpc_frontend" {
  name                    = "vpc-frontend"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub_frontend" {
  name          = "subnet-frontend"
  ip_cidr_range = "10.1.0.0/24"
  network       = google_compute_network.vpc_frontend.id
  region        = "us-central1"
}

# 2. Backend Network Configuration
resource "google_compute_network" "vpc_backend" {
  name                    = "vpc-backend"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub_backend" {
  name          = "subnet-backend"
  ip_cidr_range = "10.2.0.0/24"
  network       = google_compute_network.vpc_backend.id
  region        = "us-central1"
}

# 3. Bidirectional VPC Peering
resource "google_compute_network_peering" "peer1" {
  name         = "front-to-back"
  network      = google_compute_network.vpc_frontend.self_link
  peer_network = google_compute_network.vpc_backend.self_link
}

resource "google_compute_network_peering" "peer2" {
  name         = "back-to-front"
  network      = google_compute_network.vpc_backend.self_link
  peer_network = google_compute_network.vpc_frontend.self_link
}

# 4. Firewall Rules
# Internal Traffic (Allowing Ping and Web from Front to Back)
resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-internal-traffic"
  network = google_compute_network.vpc_backend.name
  allow { protocol = "icmp" }
  allow { protocol = "tcp"; ports = ["80", "22"] }
  source_ranges = ["10.1.0.0/24"]
}

# Secure SSH access via Google IAP Proxy
resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "allow-ssh-iap-global"
  network = google_compute_network.vpc_frontend.name
  allow { protocol = "tcp"; ports = ["22"] }
  source_ranges = ["35.235.240.0/20"]
}

# 5. Compute Instances
resource "google_compute_instance" "frontend_vm" {
  name         = "frontend-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk { initialize_params { image = "debian-cloud/debian-11" } }
  network_interface {
    subnetwork = google_compute_subnetwork.sub_frontend.id
    access_config {}
  }
}

resource "google_compute_instance" "backend_vm" {
  name         = "backend-server"
  machine_type = "e2-medium"
  zone         = "us-central1-b"
  boot_disk { initialize_params { image = "debian-cloud/debian-11" } }
  network_interface {
    subnetwork = google_compute_subnetwork.sub_backend.id
  }
}
