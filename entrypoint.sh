#!/usr/bin/env bash
set -eu

echo "${CF_BRANCH_TAG_NORMALIZED}"

if [[ -z "${CF_BUILD_ID}" ]]; then
    echo "ERROR: only runs on Codefresh"
    exit 1
fi

if [[ "${CF_BRANCH_TAG_NORMALIZED}" != "master" ]]; then
    echo "ERROR: only working on master branch"
    exit 1
fi
echo ${SSH_KEY_BASE64} | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
TZ=UTC git tag v$(date "+%Y.%m%d").$(printf %04d $(git rev-list HEAD --count --date=local --after "yesterday"))
git push --tags