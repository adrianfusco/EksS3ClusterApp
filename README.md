# EksS3ClusterApp 

The project provide a solution for creating S3 buckets and adding specific IAM policies using Terraform modules and automate the creation of a AWS EKS cluster where we will have different resources to access into S3 bucket through a Kubernetes Ingress resource.

___

## Features

This project provides:

   - Terraform modules for creating S3 buckets and adding specific IAM policies using Terraform modules.
   - A simple app done in Flask that can be used to list the content of a S3 bucket.
   - Makefile for automating almost everything specially the AWS EKS cluster creating, create the balancer that will assign a public IP to our Ingress, and apply all the manifests.
   - K8s manifests to create a namespace, service, deployment, ingress and configmap that will be used to access to a private bucket from outside.
   - A Dockerfile that will be used to build the image that will be used by one of the containers specified in the deployment.
   - GitHub CI Workflow: The project incorporates a GitHub CI workflow specifically designed to validate the syntax of the Terraform modules. This workflow automatically triggers when changes are pushed to the repository, ensuring that the modules code adheres to the expected syntax.
   - Pre-commit Hook Script and configuration: A pre-commit hook script is provided for being executed after pusing code and check syntax and liters over the code. We can find the configuration in [.pre-commit-config.yaml](./.pre-commit-config.yaml) and the script in [.githooks/pre-commit](.githooks/pre-commit).

Getting Started
---------------

## Requirements
To get started with the project, follow the steps below:

- Clone the repository:

```bash
git clone https://github.com/adrianfusco/EksS3ClusterApp.git
```

- We will require the following binaries:
    - [kubectl](https://kubernetes.io/docs/tasks/tools/): We will use it to apply the k8s configuration and manifests.
    - [helm](https://helm.sh/docs/intro/quickstart/): Used to install k8s applications. It will be useful to install the AWS balanced controller that will give us a public IP for our ingress.
    - [eksctl](https://eksctl.io/): A nice CLI app for managing AWS EKS clusters.
    - [aws](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). We need to login and it will generate the `~/.aws/credentials` that is required for different steps.
    - To run the terraform modules we need to [install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

## Set-up

### Terraform - S3 Bucket
Once we have it we can run the following commands under the `s3` module to create a bucket.

```bash
$ cd modules/s3/
$ terraform init
$ terraform plan
# We need to provide the full ARN of the user we will use with privileges
$ TF_VAR_bucket_name=BUCKET_NAME TF_VAR_user_arn=arn:aws:iam::USER_ID:user/user terraform apply
```

### AWS EKS Cluster with all resources

We can make use of the `eks_s3_cluster_setup` target specified in the Makefile. We can check this target for more information.

```
$ make eks_s3_cluster_setup
```

This one will create a AWS EKS cluster via eksctl, create our OIDC, a role for the ballancer, install our balancer via helm and apply the manifests that are under the kubernetes/manifests folder.

Note: install the binaries specified in the requirements and generate the aws credentials.

## Notes

Some problems could exist during the process and they should fixed manually, e.g. an incompability between the version of the binaries.
## Contribution


Contributions to the project are welcome! If you encounter any issues or have suggestions for improvement, please open an issue or submit a pull request on the GitHub repository.

Enabling the pre-commit hook can be useful for linters before pushing:

```
$ make

Usage:
  make <target>

General targets
  help             Display this help.

Pre-commit targets
  pre-commit       Run pre-commit script
  enable-git-hooks  Change the git hooks path for the ones stored in the .githooks folder. It will allow to run pre-commit script automatically before pushing.
```
## License

This is free and open-source software licensed under the [Apache 2.0 License](https://github.com/adrianfusco/EksS3ClusterApp/blob/main/LICENSE).

## Contact

If you have any questions or inquiries related to the project, please reach out to the project maintainer at <adrianfuscoarnejo@gmail.com>. We appreciate your feedback and suggestions.
