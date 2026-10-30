#!/bin/sh
# Configures git/gh from the environment, then hands over to opencode.
#   GITHUB_TOKEN        fine-grained PAT; used by git (HTTPS) and gh
#   GIT_AUTHOR_NAME     commit author name   (default: opencode-agent)
#   GIT_AUTHOR_EMAIL    commit author email  (default: noreply address)
set -eu

git config --global user.name "${GIT_AUTHOR_NAME:-opencode-agent}"
git config --global user.email "${GIT_AUTHOR_EMAIL:-opencode-agent@users.noreply.github.com}"
git config --global init.defaultBranch main
git config --global safe.directory '*'

if [ -n "${GITHUB_TOKEN:-}" ]; then
  # The helper reads the token from the environment at call time, so it is
  # never written to disk.
  git config --global credential.https://github.com.helper \
    '!f() { echo username=x-access-token; echo "password=${GITHUB_TOKEN}"; }; f'
  git config --global url."https://github.com/".insteadOf "git@github.com:"
else
  echo "entrypoint: GITHUB_TOKEN not set; git push/clone of private repos will fail" >&2
fi

exec opencode "$@"
