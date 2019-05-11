ARG ROS_DISTRO=kinetic
FROM thomas:ros-${ROS_DISTRO}-thomas-core

ARG THOMAS_WS=/root/thomas_ws

# Update sources
RUN apt-get update

# Install ros packages
RUN apt-get install -y \
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
RUN cd /tmp && \
    git clone http://github.com/ethz-asl/libnabo.git && \
    cd libnabo && \
    git checkout a59cd958b && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    cd /tmp && \
    git clone http://github.com/ethz-asl/libpointmatcher.git && \
    cd libpointmatcher && \
    git checkout 00004bd41 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    cd /tmp && \
    git clone http://github.com/RainerKuemmerle/g2o.git && \
    cd g2o && \
    git checkout 2e3566968 && \
    mkdir build && \
    cd build && \
    cmake -DG2O_BUILD_APPS=OFF -DG2O_BUILD_EXAMPLES=OFF .. && \
    make -j && \
    make install && \
    cd /tmp && \
    git clone http://github.com/libgit2/libgit2.git && \
    cd libgit2 && \
    git checkout v0.19.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    cd ${THOMAS_WS}/src && \
    git clone -b indigo_devel --single-branch http://github.com/ethz-asl/ethzasl_icp_mapping.git && \
    cd ethzasl_icp_mapping && \
    git apply /tmp/ethzasl_icp_mapping.patch

# Build and install thomas workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    cd ${THOMAS_WS} && \
    catkin_make && \
    rm -rf /opt/thomas && \
    catkin_make -DCMAKE_INSTALL_PREFIX=/opt/thomas install && \
    ln -s /opt/thomas/include/libpointmatcher_ros /opt/thomas/include/pointmatcher_ros

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf ~/.cmake && \
    rm -rf ${THOMAS_WS}/build && rm -rf ${THOMAS_WS}/devel

