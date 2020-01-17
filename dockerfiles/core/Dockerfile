ARG ROS_DISTRO=kinetic
FROM thomas:ros-${ROS_DISTRO}-thomas-base

ENV DEBIAN_FRONTEND noninteractive

RUN . /opt/ros/kinetic/setup.sh && \
    mkdir -p /tmp/thomas_drivers_ws/src && \
    cd /tmp/thomas_drivers_ws/src && \
    catkin_init_workspace && \
    git clone --recursive https://github.com/zju-rolab/thomas_drivers.git && \
    cd /tmp/thomas_drivers_ws && \
    catkin_make && \
    catkin_make -DCMAKE_INSTALL_PREFIX=/opt/thomas/thomas_drivers install && \
    rm -rf /tmp/thomas_drivers_ws

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf ~/.cmake
