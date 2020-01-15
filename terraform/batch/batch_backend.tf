/*
Batch Backend
*/

terraform {
  backend "gcs" {
    // NOTE: Variable interpolation is forbidden in backends.
    bucket = "distributed-nlp-emails-batch-tfstate"
    prefix = "env/prod"
  }
}
