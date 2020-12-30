FROM mcr.microsoft.com/powershell:latest

# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.18.6"
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.3.0"

# Prepare AzureCli installation
RUN apt-get update -y && apt-get install -y \
    --allow-downgrades --allow-remove-essential --allow-change-held-packages \
    python
RUN apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN export AZ_REPO=$(lsb_release -cs) && \
    echo $AZ_REPO && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# Install AzureCli
RUN apt-get update -y && apt-get install azure-cli -y

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/bin

# Install Helm
RUN curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O
RUN tar -xf helm-v3.3.0-linux-amd64.tar.gz linux-amd64/helm
RUN chmod +x linux-amd64/helm
RUN mv linux-amd64/helm /usr/bin

# Install Docker CLI
RUN apt-get update && apt-get install -y docker.io

#WORKDIR /config

CMD bash
