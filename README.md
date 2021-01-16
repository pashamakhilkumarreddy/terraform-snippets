# Sample Terraform code snippets

![Terraform Logo](https://www.terraform.io/assets/images/terraform-cloud-logo-b5dc4203.svg)

## Terraform Commands

1. ### **terraform init**: Create .terraform folder and installs the required plugins
2. ### **terraform fmt**: Format .tf files
3. ### **terraform plan**: Check for changes
4. ### **terraform apply**: Apply changes
5. ### **terraform apply -target ${resource_type}.${resource_name}**: terraform apply -target aws_instance.terraform_ec2
6. ### **terraform apply --auto-approve**: Apply changes automatically without confirmation
7. ### **terraform destroy**: Destroy all resources (just remove service related code and run terraform apply to remove specific resource/resources)
8. ### **terraform destroy -target ${resource_type}.${resource_name}**: terraform destroy -target aws_instance.terraform_ec2
9. ### **terraform.tfvars**: File to store variables
10. ### **terraform.tfstate**: Represents terraform state
11. ### **terraform state list**: Show details for all resources
12. ### **terraform show ${resource}**: Show details for individual resource
13. ### **terraform refresh**: Refresh terraform state
14. ### **terraform apply -var "variable=value"**: terraform apply -var "subnet_prefix=10.0.100.0/24"
15. ### **terraform apply -var-file file_name**: terraform apply -var-file variables.tfvars
16. ### **terraform validate**: Validate configuration
17. ### **terraform version**
18. ### **terraform output**