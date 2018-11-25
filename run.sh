#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Runs `chromium:latest` docker container that encapsulates Chromium web 
# browser (including user interface).
# Container will be built with the current (host) user hardcoded 
# and Chromium will run as this user. This way all the profile contents and 
# downloaded files are immediately available on the host, without file 
# permission issues.

set -o errexit
set -o pipefail

# You may want to change these variables

# Profile name if none is specified on command line
DEFAULT_PROFILE_NAME="default"

# Where to put all Chromium profiles on the host
PROFILE_ROOT="${HOME}/.config"

# Where to put all Chromium caches on the host
CACHE_ROOT="${HOME}/.cache"

# Where to put downloaded files
DOWNLOADS_DIR="${HOME}/Downloads"

# Limit number of CPU cores available to Chromium (0 - automatic choice)
N_CPUS=0

# Limit memory available to Chromium
MEMORY=2g

# If you want Google APIs, you should provide your own info here
GOOGLE_API_KEY="none"
GOOGLE_DEFAULT_CLIENT_ID="none"
GOOGLE_DEFAULT_CLIENT_SECRET="none"



# Use profile name from command line of the default
if [ -z "${1}"]; then
  PROFILE_NAME="${DEFAULT_PROFILE_NAME}"
else
  PROFILE_NAME="${1}"
fi

# Get directory containing this script
THIS_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

# Get working directory
PWD="$(pwd)"

# Where to put Chromium profile on the host
PROFILE_DIR="${PROFILE_ROOT}/docker-chromium-${PROFILE_NAME}"

# Where to put Chromium cache on the host
CACHE_DIR="${CACHE_ROOT}/docker-chromium-${PROFILE_NAME}"

# Detect user and group info
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(id -u -n)
GROUP_NAME=${USER_NAME}

# Generate random MAC address
MAC_ADDR="$(printf 02; od -t x1 -An -N 5 /dev/urandom | tr ' ' ':')"

# Create profile and download dirs
mkdir -p "${PROFILE_DIR}"
mkdir -p "${CACHE_DIR}"
mkdir -p "${DOWNLOADS_DIR}"

docker run --rm \
  --name "chromium-${PROFILE_NAME}" \
  --cpuset-cpus "${N_CPUS}" \
  --memory "${MEMORY}" \
  --env DISPLAY="unix${DISPLAY}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume "${PROFILE_DIR}:/home/${USER_NAME}/.config/chromium" \
  --volume "${CACHE_DIR}:/home/${USER_NAME}/.cache/chromium" \
  --volume "${DOWNLOADS_DIR}:/home/${USER_NAME}/Downloads" \
  --volume /dev/shm:/dev/shm \
  --security-opt seccomp="${THIS_DIR}/seccomp.json" \
  --device /dev/snd \
  --mac-address "${MAC_ADDR}" \
  --dns 1.0.0.1  \
  --dns 1.1.1.1  \
  --dns 8.8.8.8  \
  --dns 8.8.4.4  \
  --sysctl "net.ipv6.conf.all.disable_ipv6=1" \
  --user "${USER_ID}:${GROUP_ID}" \
  chromium:latest
