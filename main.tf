terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project               = "project-86c1cd5d-c433-4963-901"
  region                = "us-central1"
  zone                  = "us-central1-a"
  user_project_override = true
}

resource "google_compute_instance" "monitor_vm" {
  name         = "linux-health-monitor-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP assigned automatically
    }
  }

  metadata = {
    # This automatically injects your Windows computer's SSH key so you can log in later
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "vm_public_ip" {
  value       = google_compute_instance.monitor_vm.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of your new Linux VM"
}
