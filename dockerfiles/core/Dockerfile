ARG ROS_DISTRO=kinetic
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ARG THOMAS_WS=/root/thomas_ws

# Choose Ubuntu mirror
ARG UBUNTU_SOURCES_LIST=sources.list.ustc
# ARG UBUNTU_SOURCES_LIST=sources.list.tsinghua

# Choose ROS mirror
# ARG ROS_MIRROR=http://packages.ros.org/ros/ubuntu
ARG ROS_MIRROR=http://mirrors.ustc.edu.cn/ros/ubuntu
# ARG ROS_MIRROR=http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu

# Update sources
COPY ${UBUNTU_SOURCES_LIST} /etc/apt/sources.list
RUN echo "deb "${ROS_MIRROR}" $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && apt-get update

# Install ros packages
# RUN apt-get install -y \

# Install depends
RUN apt-get install -y \
    libpcap-dev \
    libraw1394-11 \
    libavcodec-ffmpeg56 \
    libavformat-ffmpeg56 \
    libswscale-ffmpeg3 \
    libswresample-ffmpeg1 \
    libavutil-ffmpeg54 \
    libgtkmm-2.4-dev \
    libglademm-2.4-dev \
    libgtkglextmm-x11-1.2-dev \
    libusb-1.0-0 \
    ros-${ROS_DISTRO}-gps-common

# Install useful tools
RUN apt-get install -y \
    vim \
    cmake-curses-gui \
    usbutils \
    gdb \
    qtcreator \
    sudo \
    terminator \
    wget

# Install on-my-zsh
RUN apt-get install -y zsh && \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY zshrc.example /root/.zshrc

# Create tmp workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    mkdir -p ${THOMAS_WS}/src && \
    cd ${THOMAS_WS}/src && \
    catkin_init_workspace .
 
# Drivers
ARG SPINNAKER_SDK_FILE=spinnaker-1.21.0.61-amd64-Ubuntu16.04-pkg.tar.gz
ARG FLYCAPTURE_SDK_FILE=flycapture2-2.13.3.31-amd64-pkg_xenial.tgz
COPY download_from_box.py /tmp
RUN cd /tmp && \
    apt-get install -y python-pip && \
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple "cryptography>2.6" "pyOpenSSL>=16.2" "boxsdk[jwt]" && \
    /usr/bin/env python download_from_box.py https://flir.app.boxcn.net/v/SpinnakerSDK spinnaker-1.21.0.61-amd64-Ubuntu16.04-pkg.tar.gz /tmp && \
    /usr/bin/env python download_from_box.py https://flir.app.boxcn.net/v/Flycapture2SDK flycapture2-2.13.3.31-amd64-pkg_xenial.tgz /tmp && \
    rm -rf /usr/local/lib/python2.7/dist-packages/* && \
    rm -rf /usr/local/lib/python2.7/site-packages/* && \
    apt-get remove -y --auto-remove python-pip && \
    cd /tmp && \
    tar -xzf ${SPINNAKER_SDK_FILE} && \
    cd /tmp && \
    tar -xzf ${FLYCAPTURE_SDK_FILE} && \
    mkdir -p /etc/udev/rules.d && \
    cd /tmp/spinnaker* && \
    echo "y\ny\nroot\ny\ny\nn\ny" | ./install_spinnaker.sh && \
    cd /tmp/flycapture* && \
    echo "y\ny\nroot\ny\ny\nn\ny" | ./install_flycapture.sh && \
    cd ${THOMAS_WS}/src && \
    git clone --recursive https://github.com/ThomasRobot/thomas_sensor_platform.git

# Build and install thomas workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    cd ${THOMAS_WS} && \
    catkin_make && \
    catkin_make -DCMAKE_INSTALL_PREFIX=/opt/thomas install

# VNC
COPY vnc /root/.vnc
RUN apt-get install -y lxde-core tightvncserver

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf ~/.cmake && \
    rm -rf ${THOMAS_WS}/build && rm -rf ${THOMAS_WS}/devel && \
    rm /ros_entrypoint.sh

# New entrypoint
COPY thomas_entrypoint.sh /
ENTRYPOINT ["/thomas_entrypoint.sh"]

