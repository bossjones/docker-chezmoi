#syntax=docker/dockerfile:1.3
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
# LABEL mantainer="Read the Docs <support@readthedocs.com>"
# LABEL version="ubuntu-22.04-2022.03.15"

# ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN apt update && apt install -y curl git gnupg zsh tar software-properties-common vim fzf perl gettext direnv vim awscli wget build-essential bash-completion

RUN sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.bin

ENV PATH /root/bin:/root/.bin:/root/.local/bin:$PATH

ENTRYPOINT ["/bin/bash"]

# Ballerina runtime distribution filename.
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Labels.
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="bossjones/docker-chezmoi"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="TonyDark Industries"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL maintainer="jarvis@theblacktonystark.com"
