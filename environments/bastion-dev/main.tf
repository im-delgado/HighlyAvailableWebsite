# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
}

# Configure the provider(s)
provider "aws" {
  region = var.region
}

module "bastion" {
  source = "../../modules/bastion"

  # Input parameters
  region                = var.region
  cluster_name          = var.cluster_name
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  ubuntu_account_number = var.ubuntu_account_number
  key_name              = var.key_name
  key_pair              = var.key_pair

}

# Add State 
terraform {
  backend "s3" {

    # If you wish to run this example manually, uncomment and fill in the config below.
    bucket         = "terraform-state-ns"
    key            = "environments/bastion-dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-ns-locks"
    encrypt        = true

  }
}
