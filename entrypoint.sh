#!/usr/bin/env bash
set -eu

if [[ "${CF_BRANCH_TAG_NORMALIZED}" != "master" ]]; then
    echo "ERROR: only working on master branch in Codefresh"
    exit 1
fi

# ssh key for git push
echo ${SSH_KEY_BASE64} | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

export TZ=UTC
COMMIT_TAG=v$(date "+%Y.%m%d").$(printf %04d $(git rev-list HEAD --count --date=local --after "yesterday"))

# tag git
git tag $COMMIT_TAG
git push --tags

# make available for other Codefresh steps
echo COMMIT_TAG=${COMMIT_TAG} >> ${CF_VOLUME_PATH}/env_vars_to_export
