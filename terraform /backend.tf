terraform {
  backend "s3" {
    bucket         = "terraform-statefile-dec5-2024"                        // replace with your configured backend s3 bucket 
    key            = "workingdir/terraform.tfstate"                        // replace with unique name
    region         = "ap-south-1"

    dynamodb_table = "terraform-state-lock"                               // Replace this with your DynamoDB table name!
    encrypt        = true
  }
}
