FROM python:3.9-alpine

# Define Terraform version
ENV TF_VERSION=1.3.9

# Install necessary dependencies
RUN apk update && apk add --no-cache \
    wget \
    unzip

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && chmod +x /usr/local/bin/terraform \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# Install Python packages
RUN pip install --no-cache-dir \
    boto3 \
    awscli
