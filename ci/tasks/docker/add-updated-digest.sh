#!/usr/bin/env bash

set -euo pipefail

# ENV
: "${COMPONENT_NAME:?}"

pushd image-resource > /dev/null
    digest="$(cat digest)"
popd

pushd cf-k8s-networking
    sed -i "s/cf-k8s-networking\/$COMPONENT_NAME@.*/cf-k8s-networking\/$COMPONENT_NAME@$digest/" config/values.yaml

    git config user.name "${GIT_COMMIT_USERNAME}"
    git config user.email "${GIT_COMMIT_EMAIL}"

    if [[ -n $(git status --porcelain) ]]; then
        echo "changes detected, will commit..."
        git add config/values.yaml
        git commit -m "Update ${COMPONENT_NAME} image digest to ${digest}"

        git log -1 --color | cat
    else
        echo "no changes in repo, no commit necessary"
    fi
popd

shopt -s dotglob
cp -r cf-k8s-networking/* cf-k8s-networking-modified
