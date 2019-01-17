#!/usr/bin/env bash
set -eu

PREFIX=v
SUFFIX="" # for dev branches

if [ -z "${CF_BRANCH_TAG_NORMALIZED}" ]; then
    echo "To be running on Codefresh only"
    exit 1
fi

if [[ "${CF_BRANCH_TAG_NORMALIZED}" != "master" ]]; then
    SUFFIX="-${CF_BRANCH_TAG_NORMALIZED}"
fi

# ssh key for git push
echo ${SSH_KEY_BASE64} | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

export TZ=UTC
COMMIT_TIMESTAMP=$(git log -1 --format="%ct")
DATE_STRING=$(date -d @${COMMIT_TIMESTAMP} "+%Y.%m%d")
COMMITS_THIS_DAY=$(printf %04d $(git rev-list HEAD --count --date=local --after="$(date -d @${COMMIT_TIMESTAMP} "+%Y-%m-%d 00:00")"))

COMMIT_VERSION=${PREFIX}${DATE_STRING}.${COMMITS_THIS_DAY}${SUFFIX}

# check if tag already exists
if [[ "$(git tag -l --points-at HEAD | grep ${COMMIT_VERSION} | wc -l)" -gt 0 ]]; then
    echo "INFO: ${COMMIT_VERSION} already pointing to this commit"
    echo COMMIT_VERSION=${COMMIT_VERSION} >> ${CF_VOLUME_PATH}/env_vars_to_export
    exit 0
fi

# tag git and push the tag to remote
git tag $COMMIT_VERSION
git push origin $COMMIT_VERSION

# make available for other Codefresh steps
echo COMMIT_VERSION=${COMMIT_VERSION} >> ${CF_VOLUME_PATH}/env_vars_to_export
