#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Builds `chromium:latest` docker container image that encapsulates Chromium web 
# browser (including user interface).
# Container will be built with the current (host) user hardcoded 
# and Chromium will run as this user. This way all the profile contents and 
# downloaded files are immediately available on the host, without file 
# permission issues.

set -o errexit
set -o pipefail

# Get directory containing this script
THIS_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

# Detect user and group info
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(id -u -n)
GROUP_NAME=${USER_NAME}

docker build --rm  \
--tag chromium:latest \
--build-arg USER_ID="${USER_ID}" \
--build-arg GROUP_ID="${GROUP_ID}" \
--build-arg USER_NAME="${USER_NAME}" \
--build-arg GROUP_NAME="${GROUP_NAME}" \
"${THIS_DIR}"
