# -*- coding: utf-8 -*-


# Describes a docker container image that encapsulates Chromium web 
# browser (including user interface).
# Container will be built with the current (host) user hardcoded 
# and Chromium will run as this user. This way all the profile contents and 
# downloaded files are immediately available on the host, without file 
# permission issues.

FROM ubuntu:bionic-20181018

LABEL maintainer "Ivan Aksamentov <ivan.aksamentov@gmail.com>"

# These arguments are automatically set by `run.sh`
ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ARG GROUP_NAME

# Convert arguments to environment variables
ENV USER_ID="${USER_ID}"
ENV GROUP_ID="${GROUP_ID}"
ENV USER_NAME="${USER_NAME}"
ENV GROUP_NAME="${GROUP_NAME}"


# Install Chromium
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --yes --no-install-recommends \
    chromium-browser \
    chromium-browser-l10n \
    dbus \
    fonts-liberation \
    fonts-roboto \
    fonts-symbola \
    hicolor-icon-theme \
    libcanberra-gtk-module \
    libexif-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpango1.0-0 \
    libv4l-0 \
    pulseaudio \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* 

# Stop complaining about machine id
RUN dbus-uuidgen > "/etc/machine-id"

# Use tini as init process
# (https://github.com/krallin/tini)
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini


# Create a user that mirrors the current host user.
# Also add this user to groups audio,video.
RUN addgroup --gid "${GROUP_ID}" "${GROUP_NAME}" \
  && adduser --system --uid "${USER_ID}" --ingroup "${GROUP_NAME}" \
  --home "/home/${USER_NAME}" --shell /bin/bash "${USER_NAME}"


ENTRYPOINT [ "/sbin/tini", "--" ]

CMD [ "/usr/bin/chromium-browser" ]
