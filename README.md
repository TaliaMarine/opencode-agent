# opencode-agent

Container image for running [opencode](https://opencode.ai) as a long-lived
server (`opencode serve`) with the tooling needed for Go, npm and TypeScript
projects on GitHub.

Published to `ghcr.io/taliamarine/opencode-agent` by GitHub Actions
(`.github/workflows/docker-publish.yml`) on changes to the image, weekly, and
on manual dispatch.

## What's inside

- opencode (`OPENCODE_VERSION` build arg, base image `ghcr.io/anomalyco/opencode`)
- git, github-cli (`gh`), openssh-client, curl, jq, make, build-base
- Go, Node.js, npm, TypeScript (`tsc`), `tsx`

## Environment

| Variable | Purpose |
|---|---|
| `GITHUB_TOKEN` | Fine-grained PAT scoped to a single repo (Contents RW, Pull requests RW, Metadata R). Used by git over HTTPS and by `gh`. Never written to disk. |
| `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` | Commit identity (defaults: `opencode-agent`, noreply address). |
| `OPENCODE_CONFIG` | Path to an `opencode.json`. |
| `OPENCODE_SERVER_PASSWORD` | Optional basic-auth password for the server. |

Go and npm caches live under `/workspace` (`GOPATH`, `GOCACHE`,
`npm_config_cache`); mount a persistent volume there.

## Running

```sh
docker run --rm -p 4096:4096 -e GITHUB_TOKEN=... \
  ghcr.io/taliamarine/opencode-agent serve --hostname 0.0.0.0 --port 4096
```

## Notes

- The image is public: never bake credentials into it.
- After the first successful build, make the GHCR package public (Package
  settings -> Change visibility) so clusters can pull it anonymously.
- Only `linux/amd64` is built.
