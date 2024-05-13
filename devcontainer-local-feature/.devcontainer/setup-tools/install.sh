#!/bin/bash

set -e

# nodejs tools
su ${_REMOTE_USER} -c "source /usr/local/share/nvm/nvm.sh && npm install -g \
    aws-cdk \
    pyright \
    " 2>&1

# python tools
pipx install poetry==1.*

# set buildx as default (docker build will point buildx automatically)
su ${_REMOTE_USER} -c "docker buildx install" 2>&1
