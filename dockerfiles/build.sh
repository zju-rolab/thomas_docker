#!/bin/bash

set -x

ROS_DISTRO=kinetic
BUILD_ARGS="--network host"
BASE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

function do_build() {
  if [ "$3" == "--force" ]; then
    ARGS="--no-cache"
  else
    ARGS=""
  fi
  docker build ${BUILD_ARGS} ${ARGS} -t thomas:ros-${ROS_DISTRO}-thomas-$1 --build-arg ROS_DISTRO=${ROS_DISTRO} $2
  return $?
}

function build_with_nv() {
  do_build $1 $1 $2
  if [ $? -ne 0 ]; then
    echo "Fail to build. Do not build nv docker"
    return
  fi
  mkdir /tmp/$1-nv
  echo "
  FROM thomas:ros-${ROS_DISTRO}-thomas-$1

  # nvidia-docker hooks
  LABEL com.nvidia.volumes.needed="nvidia_driver"
  ENV PATH /usr/local/nvidia/bin:${PATH}
  ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
  " > /tmp/$1-nv/Dockerfile
  do_build $1-nv /tmp/$1-nv
}

if [ $# -eq 0 ]; then
  for image in `ls -d ${BASE_DIR}/*/`; do
  image=$(echo ${image} | rev | cut -d'/' -f2 | rev)
  echo $image
    if [ -f "${BASE_DIR}/${image}/Dockerfile" ]; then
    build_with_nv ${image}
    fi
  done
else
  if [ $# -eq 2 ] && [ "$2" == "-f" ]; then
    build_with_nv $1 --force
  else
    build_with_nv $1 --no-force
  fi
fi

set +x 

