#!/usr/bin/env bash
set -eu

if [[ "${CF_BRANCH_TAG_NORMALIZED}" != "master" ]]; then
    echo "ERROR: only working on master branch in Codefresh"
    exit 1
fi

# ssh key for git push
echo ${SSH_KEY_BASE64} | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

export TZ=UTC
COMMIT_VERSION=v$(date "+%Y.%m%d").$(printf %04d $(git rev-list HEAD --count --date=local --after "yesterday"))

# check if tag already exists
if [[ "$(git tag -l --points-at HEAD | grep ${COMMIT_VERSION} | wc -l)" -gt 0 ]]; then
    echo "WARN: ${COMMIT_VERSION} already pointing to this commit"
    echo COMMIT_VERSION=${COMMIT_VERSION} >> ${CF_VOLUME_PATH}/env_vars_to_export
    exit 0
fi

# tag git and push the tag to remote
git tag $COMMIT_VERSION
git push origin $COMMIT_VERSION

# make available for other Codefresh steps
echo COMMIT_VERSION=${COMMIT_VERSION} >> ${CF_VOLUME_PATH}/env_vars_to_export
