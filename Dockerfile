FROM quay.io/devfile/universal-developer-image:ubi8-8419c21

USER root

# Install skaffold
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    install skaffold /usr/local/bin/

USER 1001060000
