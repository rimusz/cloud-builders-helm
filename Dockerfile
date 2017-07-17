FROM gcr.io/google_containers/ubuntu-slim:0.13

MAINTAINER Rimas Mocevicius <rmocius@gmail.com>

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV HELM_VERSION v2.5.0
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates wget \
  && rm -rf /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/archives/* \
  && wget https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} -P /tmp \
  && tar -zxvf /tmp/${HELM_FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /usr/local/bin \
  && rm -rf /tmp/*

COPY /entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
