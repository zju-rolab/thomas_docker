ARG ROS_DISTRO=kinetic
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ENV DEBIAN_FRONTEND noninteractive

# Choose Ubuntu mirror
ARG UBUNTU_SOURCES_LIST=sources.list.official
# ARG UBUNTU_SOURCES_LIST=sources.list.ustc
# ARG UBUNTU_SOURCES_LIST=sources.list.tsinghua

# Choose ROS mirror
ARG ROS_MIRROR=http://packages.ros.org/ros/ubuntu
# ARG ROS_MIRROR=http://mirrors.ustc.edu.cn/ros/ubuntu
# ARG ROS_MIRROR=http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu

# Update sources
COPY ${UBUNTU_SOURCES_LIST} /etc/apt/sources.list
RUN echo "deb "${ROS_MIRROR}" $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update

# Prepare /opt/thomas for workspace installation
RUN mkdir /opt/thomas

# Install depends
RUN apt-get install -y --allow-unauthenticated \
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

# Drivers
ARG SPINNAKER_SDK_FILE=spinnaker-1.21.0.61-amd64-Ubuntu16.04-pkg.tar.gz
ARG FLYCAPTURE_SDK_FILE=flycapture2-2.13.3.31-amd64-pkg_Ubuntu16.04.tgz
# ARG PIP_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple
ARG PIP_MIRROR=
COPY download_from_box.py /tmp
RUN cd /tmp && \
    apt-get install -y python-pip && \
    if [ -z ${PIP_MIRROR} ]; then PIP_HINT=""; else PIP_HINT="-i ${PIP_MIRROR}"; fi && \
    pip install ${PIP_HINT} "cryptography>2.6" "pyOpenSSL>=16.2" "boxsdk[jwt]" && \
    /usr/bin/env python download_from_box.py https://flir.app.boxcn.net/v/SpinnakerSDK   ${SPINNAKER_SDK_FILE}  /tmp && \
    /usr/bin/env python download_from_box.py https://flir.app.boxcn.net/v/Flycapture2SDK ${FLYCAPTURE_SDK_FILE} /tmp && \
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
    rm -rf /tmp/spinnaker* && rm -rf /tmp/flycapture*
# VNC
# COPY spv_vnc.conf /tmp
# RUN  apt install -y supervisor xvfb openbox x11vnc && \
#      cp /tmp/spv_vnc.conf /etc/supervisor/conf.d/
RUN  apt install -y supervisor xvfb openbox x11vnc

# Install VSCode
RUN cd /tmp && \
    apt install -y apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt update && \
    apt install -y code # or code-insiders

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf ~/.cmake

# New entrypoint
RUN rm /ros_entrypoint.sh
COPY thomas_entrypoint.sh /
ENTRYPOINT ["/thomas_entrypoint.sh"]

