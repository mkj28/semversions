#!/usr/bin/env bash
set -eu

echo ${SSH_KEY_BASE64} | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
TZ=UTC git tag v$(date "+%Y.%m%d").$(printf %04d $(git rev-list HEAD --count --date=local --after "yesterday"))
git push --tags