terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("gcp-key.json")
  project     = "probable-lore-479409-t9"                 # ← CHANGE TO YOUR PROJECT ID!
  region      = "us-central1"
  zone        = "us-central1-a"
}

resource "google_compute_instance" "esg_vm" {
  name         = "esg-bonus-vm-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  machine_type = "e2-medium"    # 2 vCPU, 4 GB RAM
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    network = "default"
    access_config {}  # gives public IP
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/almaz/.ssh/id_ed25519.pub")}"
  }

  metadata_startup_script = "echo 'VM created by Terraform for SIS Bonus' > /root/hello.txt"
}

output "vm_external_ip" {
  value = google_compute_instance.esg_vm.network_interface[0].access_config[0].nat_ip
}
