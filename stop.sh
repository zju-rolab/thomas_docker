#!/usr/bin/env bash

CONTAINER_NAME=thomas_os

docker container stop ${CONTAINER_NAME} > /dev/null
