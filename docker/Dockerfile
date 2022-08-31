##
#  Generic dockerfile for dbt image building
##

FROM --platform=$BUILDPLATFORM ghcr.io/dbt-labs/dbt-core:1.1.2 AS base

# Base env vars
ENV TZ="Europe/Madrid"
ENV SRC_PATH=/opt/pulpo22
ENV DBT_PROFILES_DIR=/opt/dbt/config

RUN mkdir -p $SRC_PATH
RUN mkdir -p $DBT_PROFILES_DIR

# Update environment
RUN pip install --upgrade pip

# Install python packages
COPY ./dbt/requirements.txt $SRC_PATH/requirements.txt
RUN pip install -r $SRC_PATH/requirements.txt


##
#  Image used for local development
##

FROM --platform=$BUILDPLATFORM base AS dev

ARG USER_NAME=local-dev
ARG USER_ID=1000
ARG GROUP_ID=1000

# User config
RUN groupadd -g $GROUP_ID -o $USER_NAME
RUN useradd -m -u $USER_ID -g $GROUP_ID -o -s /bin/bash $USER_NAME

# Set docker basics
WORKDIR $SRC_PATH
ENTRYPOINT []


##
#  Image used for unit testing
##

FROM --platform=$BUILDPLATFORM base AS test

COPY ./config/dbt/profiles.yml $DBT_PROFILES_DIR/profiles.yml
COPY ./dbt $SRC_PATH

# Set docker basics
WORKDIR $SRC_PATH
ENTRYPOINT []