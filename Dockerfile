FROM gcr.io/cloud-builders/gcloud

LABEL maintainer="Rimas Mocevicius <rmocius@gmail.com>"

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV DESIRED_VERSION _RELEASE_

RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates curl git \
  && rm -rf /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/archives/* \
  && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > /tmp/get_helm.sh \
  && chmod 700 /tmp/get_helm.sh \
  && /tmp/get_helm.sh \
  && rm -rf /tmp/* \
  && helm plugin install https://github.com/rimusz/helm-tiller \
  && helm plugin install https://github.com/viglesiasce/helm-gcs.git --version v0.2.0 \
  && helm plugin install https://github.com/databus23/helm-diff --version master \
  && curl -SsL https://github.com/roboll/helmfile/releases/download/v0.68.1/helmfile_linux_amd64 > helmfile \
  && chmod 700 helmfile

COPY /entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
