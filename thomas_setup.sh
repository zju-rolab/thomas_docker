#!/usr/bin/env bash

CONTAINER_NAME=thomas_os

BASE_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"

. "${BASE_DIR}/functions.sh"

if $(read_confirm_y "Enter docker (start if necessary)" 5) ; then

  # Only take effect in terminal
  if [ -n "${TERM}" ]; then

    # "Running"
    if [ -n "$(docker container ls -f "name=${CONTAINER_NAME}" -f "status=running" --format {{.ID}})" ]; then
      sh ${BASE_DIR}/into.sh

    else # "Exited", "paused" or "not exist"

      # "Paused"
      if [ -n "$(docker container ls -a -f "name=${CONTAINER_NAME}" -f "status=paused" --format {{.ID}})" ]; then
        sh ${BASE_DIR}/unpause.sh
      
      # "Exited" or "nor exist"
      else
        sh ${BASE_DIR}/start.sh
      fi

      sh ${BASE_DIR}/into.sh

    fi
  fi

fi