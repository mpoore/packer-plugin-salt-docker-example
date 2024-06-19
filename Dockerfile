FROM ubuntu:latest
ARG VERSION
ARG TARGETPLATFORM
ARG ARCH
LABEL maintainer="mpoore.io"
LABEL version="$VERSION"

# Update packages and install new ones
RUN apt-get update && apt-get upgrade -y && apt-get install curl sudo -y

# Import key
#RUN rpm --import https://repo.saltproject.io/salt/py3/photon/5.0/aarch64/latest/SALT-PROJECT-GPG-PUBKEY-2023.pub

# Setup repo
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")  TARGET_ARCH=amd64  ;; \
         "linux/arm64")  TARGET_ARCH=arm64  ;; \
         *) exit 1 ;; \
    esac; \
    curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/ubuntu/24.04/$TARGET_ARCH/SALT-PROJECT-GPG-PUBKEY-2023.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=$TARGET_ARCH] https://repo.saltproject.io/salt/py3/ubuntu/24.04/$TARGET_ARCH/latest noble main" | tee /etc/apt/sources.list.d/salt.list

# Install Salt
RUN apt-get update && apt-get upgrade -y && apt-get install salt-minion -y

# Complete
ADD VERSION .