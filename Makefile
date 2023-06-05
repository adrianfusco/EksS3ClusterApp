SHELL := /bin/bash

## Macros
check_binary_exists = $(if $(strip $(shell command -v $1)),,$(error "$1" command not found. Make sure it is installed and in your system's PATH.))

AWS_REGION ?= default
define vars
${1}: export BUCKET_NAME=${BUCKET_NAME}
${1}: export USER_ARN=${USER_ARN}
${1}: export AWS_REGION=${AWS_REGION}
${1}: export AWS_CLUSTER_NAME=${AWS_CLUSTER_NAME}
${1}: export USER_ARN_ID=${USER_ARN_ID}
endef

BLUE = \033[36m
RESET = \033[0m
.PHONY: help
help:
	@awk 'BEGIN { \
		FS = ":.*##"; \
		printf "\nUsage:\n  make $(BLUE)<target>$(RESET)\n" \
	} \
	/^[a-zA-Z_0-9-]+:.*?##/ { \
		printf "  $(BLUE)%-15s$(RESET) %s\n", $$1, $$2 \
	} \
	/^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	}' $(MAKEFILE_LIST)


##@ Pre-commit targets
.PHONY: pre_commit
pre-commit: ## Run pre-commit script
	bash ./.githooks/pre-commit

.PHONY: enable-git-hooks
enable-git-hooks: ## Change the git hooks path for the ones stored in the .githooks folder. It will allow to run pre-commit script automatically before pushing.
	git config core.hooksPath "./.githooks"
	chmod ug+x ./.githooks/*


##@ Terraform modules targets
.PHONY: s3_bucket_w_policy
s3_bucket_w_policy: ## Creates a S3 bucket with List and Put enabled policies for the provided user.
	$(call check_binary_exists,"terraform"):
	pushd terraform/modules/s3/; \
	terraform init; \
	TF_VAR_bucket_name=${BUCKET_NAME} TF_VAR_user_arn=${USER_ARN} TF_VAR_region=${AWS_REGION} terraform apply; \
	popd;

##@ AWS k8s targets
.PHONY: create_aws_eks_cluster
create_aws_eks_cluster: # Creates AWS EKS cluster via eksctl. The aws credentials should be configured
	@if ! [ -e ~/.aws/credentials ]; then \
		echo "File ~/.aws/credentials does not exist"; \
		exit 1; \
	fi
	$(call check_binary_exists,"eksctl"):
	$(call check_binary_exists,"helm"):
	eksctl create cluster --name=${AWS_CLUSTER_NAME} --region=${AWS_REGION};
	eksctl utils associate-iam-oidc-provider --cluster=${AWS_CLUSTER_NAME} --region=${AWS_REGION} --approve;
	eksctl create iamserviceaccount \
		--cluster=${AWS_CLUSTER_NAME} \
		--namespace=kube-system \
		--name=aws-load-balancer-controller \
		--role-name AmazonEKSLoadBalancerControllerRole \
		--attach-policy-arn=arn:aws:iam::${USER_ARN_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
		--approve;
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
		-n kube-system \
		--set clusterName=${AWS_CLUSTER_NAME} \
		--set serviceAccount.create=false \
		--set serviceAccount.name=aws-load-balancer-controller;


.PHONY: apply_k8s_manifests
apply_k8s_manifests: # Apply the manifests that are under the kubernetes/manifests folder
	$(call check_binary_exists,"kubectl"):
	pushd kubernetes/manifests/; \
	kubectl create configmap nginx-config --from-file=default.conf; \
	kubectl apply -f namespace.yaml; \
	kubectl apply -f deployment.yaml; \
	kubectl apply -f service.yaml; \
	kubectl apply -f ingress.yaml; \
	popd;

.PHONY: eks_s3_cluster_setup
eks_s3_cluster_setup: create_aws_eks_cluster apply_k8s_manifests ## This target will automate the creation of the EKS cluster via eksctl, create the required policies and apply the manifests to configure the service, deployment and ingress.
