# Posit Take-Home Assignment

This repository can be used to deploy the following resources in AWS using Terraform:

* **EC2 instance:** This instance contains a shell script, `download_random_wikipedia_article.sh`, that is scheduled (via cron) to download an HTML file representing a random Wikipedia article nightly at midnight and save it to disk. These files are saved under `/home/ec2-user/app/output`.
* **Network resources:** Also included are network resources (VPC, security group, etc.) that house the EC2 instance and support remote access via EC2 Instance Connect and SSH.

This is OK as an example but would obviously not be suited to production use. A more robust approach might include scheduled compute resources (e.g., a Lambda function or an ECS scheduled task), writing the files to permanent object storage (e.g., S3), logging and error monitoring, etc.

## How to deploy

To deploy the infrastructure from the project root via the Terraform CLI:

```sh
terraform init
terraform apply
```

When you're ready to tear down the deployed resources, execute the following:

```sh
terraform init
terraform destroy
```

## Continuous integration

This repository contains a GitHub Actions configuration that will automatically deploy commits on the `main` branch to AWS using Terraform. In order for deployment to succeed, the secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` must be specified in the GitHub repository's "Actions secrets and variables" settings.

Please note: because the example configuration does not include a remote data store for the Terraform state, currently the CI workflow will just create new and duplicative resources rather than managing existing ones. In a production environment we'd want to use S3 or another remote backend to store the Terraform state.
