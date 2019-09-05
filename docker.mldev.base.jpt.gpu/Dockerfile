# ==================================================================
# module list
# ------------------------------------------------------------------
# python        3.6    (apt) O
# jupyter       latest (pip) O
# onnx          latest (pip) O
# pytorch       latest (pip) O
# tensorflow    latest (pip) O
# ==================================================================

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
ENV LANG C.UTF-8

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \

    apt-get update && \

# ==================================================================
# tools
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        wget \
        git \
        vim \
        libssl-dev \
        curl \
        unzip \
        unrar \
        && \

# CUSTOM ---------------------------------------------------------------------->

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        sudo \
        zip \
        nano \
        tmux \
        tree \
        mc \
        nodejs \
        npm \
        # openssh-server \
        rsync \
        sshfs \
        # libsndfile1 \
        # python3-dev \
        # python3-pip \
        # python3-tk \
        && \

# CUSTOM ----------------------------------------------------------------------<

    $GIT_CLONE https://github.com/Kitware/CMake ~/cmake && \
    cd ~/cmake && \
    ./bootstrap && \
    make -j"$(nproc)" install && \

# ==================================================================
# python
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        python3-distutils-extra \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-learn \
        matplotlib \
        Cython \
        && \

# ==================================================================
# onnx
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        protobuf-compiler \
        libprotoc-dev \
        && \

    $PIP_INSTALL \
        onnx \
        && \

# ==================================================================
# pytorch
# ------------------------------------------------------------------

    $PIP_INSTALL \
        future \
        numpy \
        protobuf \
        enum34 \
        pyyaml \
        typing

#-------------------------------------------------------------------------------
# CPU (TF1)
# ARG tensorflow_ver='tensorflow==1.14.0'
# ARG torch_ver='torch==1.2.0+cpu'
# ARG torchvision_ver='torchvision==0.4.0+cpu -f https://download.pytorch.org/whl/torch_stable.html'

# CPU (TF2)
# ARG tensorflow_ver='tensorflow==2.0.0-rc0'
# ARG torch_ver='torch==1.2.0+cpu'
# ARG torchvision_ver='torchvision==0.4.0+cpu -f https://download.pytorch.org/whl/torch_stable.html'

# GPU (TF1)
# ARG tensorflow_ver='tensorflow-gpu==1.14.0'
# ARG torch_ver='torch==1.2.0'
# ARG torchvision_ver='torchvision==0.4.0 -f https://download.pytorch.org/whl/torch_stable.html'

# GPU (TF2)
ARG tensorflow_ver='tensorflow-gpu==2.0.0-rc0'
ARG torch_ver='torch==1.2.0'
ARG torchvision_ver='torchvision==0.4.0 -f https://download.pytorch.org/whl/torch_stable.html'
#-------------------------------------------------------------------------------

RUN PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        ${torch_ver} \
        ${torchvision_ver} \
        && \

# ==================================================================
# tensorflow
# ------------------------------------------------------------------

    $PIP_INSTALL \
        ${tensorflow_ver}

# CUSTOM ---------------------------------------------------------------------->

RUN PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        # ipython \
        # jupyterlab \
        numba \
        cupy-cuda100 \
        tensorboardX \
        unidecode \
        # num2words \
        # nltk \
        # jamo \
        # inflect \
        # librosa \
        # soundfile \
        tqdm \
        json5 \
        pytest \
        pytest-cov \
        boto3 \
        && \

# CUSTOM ----------------------------------------------------------------------<

# ==================================================================
# jupyter
# ------------------------------------------------------------------

    $PIP_INSTALL \
        jupyter \
        && \

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------

    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

#===============================================================================
# MISC
#-------------------------------------------------------------------------------
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#===============================================================================
# workspace
#-------------------------------------------------------------------------------
ARG workspace=/workspace
ENV WORKSPACE ${workspace}
RUN mkdir -p ${workspace}
WORKDIR ${workspace}

#===============================================================================
# root password
#-------------------------------------------------------------------------------
ARG root_passwd=root
RUN echo "root:${root_passwd}" | chpasswd

#===============================================================================
# user [coder:coder]
#-------------------------------------------------------------------------------
ARG user=coder
ARG group=coder
ARG uid=911
ARG gid=911
ARG passwd=coder

RUN groupadd -g ${gid} ${group} \
  && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
  && echo "${user}:${passwd}" | chpasswd \
  && adduser ${user} sudo

# ==================================================================
# tensorboard
# ------------------------------------------------------------------
EXPOSE 6006

#===============================================================================
# jupyter
#-------------------------------------------------------------------------------
EXPOSE 8888

#===============================================================================
# entrypoint
#-------------------------------------------------------------------------------
COPY bashrc.sh /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc

COPY start.sh /
RUN chmod u+x /start.sh

ENV NOTEBOOKAPP_PASSWORD="FIX_ME"
ENV PUID=5555
ENV PGID=5555
CMD ["/start.sh"]
#-------------------------------------------------------------------------------
