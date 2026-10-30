# opencode (https://opencode.ai) plus the toolchain needed to work on
# Go / npm / TypeScript projects hosted on GitHub.
ARG OPENCODE_VERSION=1.19.5
FROM ghcr.io/anomalyco/opencode:${OPENCODE_VERSION}

RUN apk add --no-cache \
      bash \
      build-base \
      curl \
      git \
      github-cli \
      go \
      jq \
      make \
      nodejs \
      npm \
      openssh-client \
 && npm install -g --no-fund --no-audit typescript tsx

# Keep language caches on the persistent volume (HOME is /workspace in the
# cluster) so dependency downloads survive pod restarts.
ENV GOPATH=/workspace/go \
    GOCACHE=/workspace/.cache/go-build \
    npm_config_cache=/workspace/.npm \
    PATH=/workspace/go/bin:$PATH

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
