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
  name = "my_terraform_bucket_banka_email"
}

# This will copy my source file (zip format) from local directory and paste it inside the bucket
resource "google_storage_bucket_object" "archive" {
  name   = "main.zip"
  bucket = "${google_storage_bucket.my-bucket.name}"
  source = "/Users/bankapraharaj/Documents/GCP/practice/terraform/cloudfunctionemail/src/main.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "terraform-cloud-function-email"
  description = "An example Cloud Function that is triggered by a Cloud Schedule."
  runtime     = "python37"


  available_memory_mb   = 128
  source_archive_bucket = "${google_storage_bucket.my-bucket.name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  entry_point           = "hello_pubsub" # This is the name of the function that will be executed in your Python code

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource = "dataflow-fail2"  # interpolation referencing
  }
}
