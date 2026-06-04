# Configure the Google Cloud Provider using your local login
provider "google" {
  project = "calm-inkwell-475719-p1" # Replace with your actual GCP Project ID
  region  = "us-central1"
  zone    = "us-central1-a"
  # Notice: The `credentials = file(...)` line is completely gone!
}
