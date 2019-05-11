#!/usr/bin/env bash

CONTAINER_NAME=thomas_os
IMAGE_NAME=thomas:ros-kinetic-thomas-core

BASE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

# User imformation
USER_ID=$(id -u)
GRP=$(id -g -n)
GRP_ID=$(id -g)
USER_CONF="-e DOCKER_USER=$USER -e DOCKER_USER_ID=$USER_ID -e DOCKER_GRP=$GRP -e DOCKER_GRP_ID=$GRP_ID"
# Append group name & id for pointgrey if possible
PG_GRP='flirimaging'
if [ -n $(grep ${PG_GRP} /etc/group) ]; then
  USER_CONF="${USER_CONF} -e PG_GRP_ID=`grep ${PG_GRP} /etc/group | cut -d':' -f 3`"
  USER_CONF="${USER_CONF} -e PG_GRP=${PG_GRP}"
fi

if [ "$USER" = "root" ]; then
  DOCKER_HOME="/root"
else
  DOCKER_HOME="/home/$USER"
fi

# Use ~/.thomas to save persistent files
if [ ! -d $HOME/.thomas ]; then
  mkdir -p $HOME/.thomas
fi

# Some mounts
MOUNTS="\
  -v /media:/media \
  -v /dev:/dev \
  -v $HOME/.thomas:${DOCKER_HOME}/.thomas \
  -v ${BASE_DIR}/scripts:/thomas/scripts \
"
# Gazebo directory
if [ -d $HOME/.gazebo ]; then
  MOUNTS="${MOUNTS} -v $HOME/.gazebo:${DOCKER_HOME}/.gazebo"
fi
# If USB containing a valid workspace (1. file `THOMAS_WORKSPACE` exists, 2. directory `src` exists), set it as workspace
if [ -d $HOME/catkin_ws ]; then
  MOUNTS="${MOUNTS} -v $HOME/catkin_ws:${DOCKER_HOME}/catkin_ws"
  for disk in `ls /media/$USER`; do
    if [ -f "/media/$USER/${disk}/THOMAS_WORKSPACE" ] && [ -d "/media/$USER/${disk}/src" ]; then
      MOUNTS="${MOUNTS} -v /media/$USER/${disk}/src:${DOCKER_HOME}/catkin_ws/src"
    fi
  done
fi

# Use nvidia-docker if exists
if [ -n "`command -v nvidia-docker`" ]; then
  DOCKER_CMD=nvidia-docker
  IMAGE_NAME="${IMAGE_NAME}-nv"
else
  DOCKER_CMD=docker
fi

# Display configuration
DISPLAY_CONF="-e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw"

# Network configuration
HOST_HOSTNAME=`hostname`
LOCAL_HOSTNAME=docker-on-${HOST_HOSTNAME}
NET_CONF="\
  --hostname ${LOCAL_HOSTNAME} \
  --add-host ${LOCAL_HOSTNAME}:127.0.0.1 \
  --add-host ${HOST_HOSTNAME}:127.0.0.1 \
"

# Set ROS_IP & ROS_MASTER_URI from environment variables
if [ -n "$ROS_IP" ]; then
  echo "Using ROS_IP=${ROS_IP}"
  NET_CONF="${NET_CONF} -e ROS_IP=${ROS_IP}"
fi
if [ -n "$ROS_MASTER_URI" ]; then
  echo "Using ROS_MASTER_URI=${ROS_MASTER_URI}"
  NET_CONF="${ROS_MASTER_URI} -e ROS_MASTER_URI=${ROS_MASTER_URI}"
fi

# Some system specific configuration
if [ $(uname) = 'Linux' ]; then
  MOUNTS="${MOUNTS} -v /etc/localtime:/etc/localtime:ro"
  DISPLAY_CONF="${DISPLAY_CONF} -e DISPLAY=:0"
  NET_CONF="${NET_CONF} --net host"
elif [ $(uname) = 'Darwin' ]; then
  DISPLAY_CONF="${DISPLAY_CONF} -e DISPLAY=host.docker.internal:0 -e LIBGL_ALWAYS_SOFTWARE=1"
  NET_CONF="${NET_CONF} -p 11311:11311"
fi

if [ -n "$(docker container ls -a -f "name=${CONTAINER_NAME}" -f "status=exited" --format {{.ID}})" ]; then
  # Continue the exited container if exists
  docker start ${CONTAINER_NAME} > /dev/null
else
  # Do the real run
  ${DOCKER_CMD} run -it -d --privileged \
                    --name ${CONTAINER_NAME} \
                    ${DISPLAY_CONF} \
                    ${NET_CONF} \
                    ${USER_CONF} \
                    ${MOUNTS} \
                    -w ${DOCKER_HOME} \
                    ${IMAGE_NAME} \
                    /bin/zsh -c 'source /opt/ros/${ROS_DISTRO}/setup.zsh && roscore' > /dev/null
fi
