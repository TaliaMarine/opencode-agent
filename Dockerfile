# opencode (https://opencode.ai) plus the toolchain needed to work on
# Go / npm / TypeScript projects hosted on GitHub.
ARG OPENCODE_VERSION=1.19.5
ARG UV_VERSION=0.13.6

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

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
      py3-pip \
      python3 \
 && npm install -g --no-fund --no-audit typescript tsx

COPY --from=uv /uv /uvx /usr/local/bin/

# Keep language caches on the persistent volume (HOME is /workspace in the
# cluster) so dependency downloads survive pod restarts.
ENV GOPATH=/workspace/go \
    GOCACHE=/workspace/.cache/go-build \
    npm_config_cache=/workspace/.npm \
    UV_CACHE_DIR=/workspace/.cache/uv \
    UV_PYTHON_PREFERENCE=only-system \
    PATH=/workspace/go/bin:$PATH

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
