############################################################
# Dockerfile to manage certificates
# https://github.com/Unixono/docker-certs-manager
############################################################
FROM ubuntu:trusty
MAINTAINER Facundo Victor <facundovt@gmail.com>
ENV IMG_VER v0.0.1

# Install dependencies
RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.listi \
    && apt-get update \
    && apt-get install -y python openssl

# Path where the keys, csrs, certs and challenges will be stored
ENV WORKDIR_PATH /var/lib/letsencript
RUN mkdir -p $WORKDIR_PATH

# Create the user acme
RUN groupadd -r acme && useradd -r -m -g acme acme

# Grant permissions to the working directory
RUN chown acme:acme $WORKDIR_PATH && chmod 755 $WORKDIR_PATH

# Copy the scripts
COPY manage_certs.sh /home/acme/manage_certs.sh
COPY acme-tiny /home/acme/acme-tiny

# Set the user acme as default
USER ACME
# Sets the default working directory
WORKDIR /home/acme
