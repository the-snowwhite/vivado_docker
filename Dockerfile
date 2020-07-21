FROM ubuntu:18.04 as stage1
MAINTAINER Michael Brown <producer@holotronic.dk>

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  lsb-release \
  software-properties-common

RUN add-apt-repository ppa:xorg-edgers/ppa
RUN apt-get update && apt-get install -y \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  libgl1-mesa-dev
RUN add-apt-repository --remove ppa:xorg-edgers/ppa
RUN apt-get update && apt-get install -y \
  net-tools \
  unzip \
  gcc \
  g++ \
  python
COPY xrt_202010.2.6.655_18.04-amd64-xrt.deb /tmp/
RUN apt-get install -y /tmp/xrt_202010.2.6.655_18.04-amd64-xrt.deb && rm -rf /tmp/*

# copy in config file
COPY install_config-vitis.txt /tmp/
ADD Xilinx_Unified_2020.1_0602_1208.tar.gz /tmp/

RUN /tmp/Xilinx_Unified_2020.1_0602_1208/xsetup -a XilinxEULA,3rdPartyEULA,WebTalkTerms -b Install -c /tmp/install_config-vitis.txt && \
    rm -rf /tmp/*

FROM ubuntu:18.04

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  lsb-release \
  software-properties-common

RUN add-apt-repository ppa:xorg-edgers/ppa
RUN apt-get update && apt-get install -y \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  libgl1-mesa-dev
RUN add-apt-repository --remove ppa:xorg-edgers/ppa
RUN apt-get update && apt-get install -y \
  net-tools \
  unzip \
  gcc \
  g++ \
  python
COPY xrt_202010.2.6.655_18.04-amd64-xrt.deb /tmp/
RUN apt-get install -y /tmp/xrt_202010.2.6.655_18.04-amd64-xrt.deb && rm -rf /tmp/*

# turn off recommends on container OS
# install required dependencies
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
    /etc/apt/apt.conf.d/01norecommend && \
    apt-get update && \
    apt-get -y install \
        bzip2 \
        libc6-i386 \
        git \
        libfontconfig1 \
        libglib2.0-0 \
        sudo \
        nano \
        locales \
        libxext6 \
        libxrender1 \
        libxtst6 \
        libgtk2.0-0 \
        build-essential \
        ruby \
        ruby-dev \
        pkg-config \
        libprotobuf-dev \
        protobuf-compiler \
        python-protobuf \
        python-pip && \
        pip install intelhex && \
        echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
        locale-gen && \
        gem install fpm && \
        apt-get clean

COPY --from=stage1 /tools/Xilinx /tools/Xilinx

RUN useradd -m vivado && echo "vivado:vivado" | chpasswd && adduser vivado sudo
USER vivado
WORKDIR /home/vivado

#add vivado tools to path
#copy in the license file
RUN echo "source /tools/Xilinx/Vivado/2020.1/settings64.sh" >> /home/vivado/.bashrc && \
    mkdir /home/vivado/.Xilinx

# customize gui (font scaling 125%)
COPY --chown=vivado:vivado vivado.xml /home/vivado/.Xilinx/Vivado/2020.1/vivado.xml

# add U96 board files
ADD /board_files.tar.gz /tools/Xilinx/Vivado/2020.1/data/boards/
