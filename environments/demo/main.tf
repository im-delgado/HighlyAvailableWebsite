# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
}

# Configure the provider(s)
provider "aws" {
  region = "us-east-1" # N. Virginia (US East)
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  # Input parameters
  cluster_name  = var.cluster_name
  instance_type = var.instance_type # "t2.micro"
  min_size      = var.min_size      # 2
  max_size      = var.max_size      # 2
}

# Add State 
terraform {
  backend "s3" {

    # If you wish to run this example manually, uncomment and fill in the config below.
    bucket         = "terraform-state-ns"
    key            = "environments/demo/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-ns-locks"
    encrypt        = true

  }
}

# resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
#   scheduled_action_name = "scale-out-during-business-hours"
#   min_size              = 2
#   max_size              = 10
#   desired_capacity      = 10
#   recurrence            = "0 9 * * *"

#   autoscaling_group_name = module.webserver_cluster.asg_name
# }

# resource "aws_autoscaling_schedule" "scale_in_at_night" {
#   scheduled_action_name = "scale-in-at-night"
#   min_size              = 2
#   max_size              = 10
#   desired_capacity      = 2
#   recurrence            = "0 17 * * *"

#   autoscaling_group_name = module.webserver_cluster.asg_name
# }