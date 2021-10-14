terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("/Users/bankapraharaj/Documents/GCP/practice/terraform/feisty-lamp-299522-db6fa0da6ba6.json")

  project = "feisty-lamp-299522"
  region  = "us-east4"
  zone    = "us-east4-b"
}

resource "google_storage_bucket" "my-bucket" {
  name = "my_terraform_bucket_2"
}

