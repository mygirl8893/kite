FROM ruby:2.4.1

RUN apt-get update && apt-get install -y zip curl wget

ARG TERRAFORM_VERSION=0.10.8
ARG BOSH_VERSION=2.0.44
ARG GCLOUD_VERSION=178.0.0

# Install Terraform
RUN curl -Ls https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform -d /usr/bin/terraform \
    && chmod +x /usr/bin/terraform \
    && rm -f terraform.zip

# Install BOSH v2
RUN curl -Ls https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64 -o /usr/bin/bosh \
    && chmod +x /usr/bin/bosh

# Install gcloud
RUN set -ex \
    && cd /usr/local/ \
    && curl -LsO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && tar xvf google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh -q --rc-path /etc/profile.d/gcloud.sh --additional-components kubectl docker-credential-gcr \
    && rm google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz

ENV PATH=/usr/local/google-cloud-sdk/bin:${PATH}

# Install helm
RUN curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Install Kite
RUN gem install kite
