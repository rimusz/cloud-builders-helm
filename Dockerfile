FROM gcr.io/google_containers/ubuntu-slim:0.13

MAINTAINER Rimas Mocevicius <rmocius@gmail.com>

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV HELM_VERSION _RELEASE_
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz

ADD https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} /tmp

RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  && rm -rf /tmp/* /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/archives/* \
  && tar -zxvf /tmp/${HELM_FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /usr/local/bin \
  && rm -rf /tmp/*

COPY helm.sh /usr/local/bin/helm.sh

ENTRYPOINT ["helm.sh"]
