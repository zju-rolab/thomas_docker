#!/usr/bin/env bash

CONTAINER_NAME=thomas_os

xhost +local:root 1>/dev/null 2>&1

wait_cnt=5
while [ $wait_cnt -gt 0 ]; do
  ret=$(docker exec ${CONTAINER_NAME} /bin/zsh -c "cat /etc/passwd | cut -d':' -f1 | grep $USER")
  if [ -n "$ret" ]; then
    break
  fi
  i=$[$i-1]
  echo "Waiting"
  sleep 1
done

docker exec -it -u ${USER} ${CONTAINER_NAME} /bin/zsh -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec zsh"

xhost -local:root 1>/dev/null 2>&1
