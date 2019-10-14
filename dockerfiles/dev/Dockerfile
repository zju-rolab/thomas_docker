ARG ROS_DISTRO=kinetic
FROM thomas:ros-${ROS_DISTRO}-thomas-core

ARG THOMAS_WS=/root/thomas_ws

# Update sources
RUN apt-get update

# Install ros packages
RUN apt-get install -y --allow-unauthenticated \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-gps-common \
    ros-${ROS_DISTRO}-tf2-eigen \
    ros-${ROS_DISTRO}-diff-drive-controller \
    ros-${ROS_DISTRO}-controller-manager \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-joy-teleop \
    ros-${ROS_DISTRO}-map-server \
    ros-${ROS_DISTRO}-tf2-sensor-msgs

# Install depends
RUN apt-get install -y \
    libopencv-dev \
    libsuitesparse-dev \
    libgoogle-glog-dev \
    python-serial

# 3rd party libraries
COPY ethzasl_icp_mapping.patch /tmp/ethzasl_icp_mapping.patch
RUN cd /tmp && git clone http://github.com/ethz-asl/libnabo.git && \
    cd /tmp/libnabo && \
    git checkout a59cd958b && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    rm -rf /tmp/libnabo && \
    cd /tmp && git clone http://github.com/ethz-asl/libpointmatcher.git && \
    cd /tmp/libpointmatcher && \
    git checkout 00004bd41 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    rm -rf /tmp/libpointmatcher && \
    cd /tmp && git clone http://github.com/RainerKuemmerle/g2o.git && \
    cd /tmp/g2o && \
    git checkout 2e3566968 && \
    mkdir build && \
    cd build && \
    cmake -DG2O_BUILD_APPS=OFF -DG2O_BUILD_EXAMPLES=OFF .. && \
    make -j4 && \
    make install && \
    rm -rf /tmp/g2o && \
    cd /tmp && git clone http://github.com/libgit2/libgit2.git && \
    cd /tmp/libgit2 && \
    git checkout v0.19.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    rm -rf /tmp/libgit2 && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    mkdir -p /tmp/pointmatcher_ros_ws/src && \
    cd /tmp/pointmatcher_ros_ws/src && \
    catkin_init_workspace . && \
    git clone -b indigo_devel --single-branch http://github.com/ethz-asl/ethzasl_icp_mapping.git && \
    cd ethzasl_icp_mapping && \
    git apply /tmp/ethzasl_icp_mapping.patch && \
    cd /tmp/pointmatcher_ros_ws && \
    catkin_make && \
    catkin_make -DCMAKE_INSTALL_PREFIX=/opt/thomas/pointmatcher_ros install && \
    ln -s /opt/thomas/pointmatcher_ros/include/libpointmatcher_ros /opt/thomas/pointmatcher_ros/include/pointmatcher_ros && \
    rm -rf /tmp/pointmatcher_ros_ws

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf ~/.cmake

