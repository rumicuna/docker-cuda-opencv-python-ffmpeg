FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer martin@rumicuna.com

#2.7
ENV PYTHON_VERSION 2.7

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    libatlas-base-dev \
    libboost-all-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libprotobuf-dev \
    libsnappy-dev \
    protobuf-compiler \
    python$PYTHON_VERSION-dev \
    python-numpy \
    python-setuptools \
    python-scipy \
    curl \
    ffmpeg \
    python-tk \
    vim 

# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
        python get-pip.py && \
        rm get-pip.py

# Install other useful Python packages using pip
RUN pip --no-cache-dir install \
                configobj \
                config_reader \
                protobuf \
                opencv-python \
                joblib

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

# FIXME: use ARG instead of ENV once DockerHub supports this
# https://github.com/docker/hub-feedback/issues/460
#ENV CLONE_TAG=1.0
#RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \

RUN git clone --depth 1 https://github.com/rumicuna/caffe.git . && \
    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
    git clone https://github.com/NVIDIA/nccl.git && cd nccl && make -j install && cd .. && rm -rf nccl && \
    mkdir build && cd build && \
    cmake -DUSE_CUDNN=1 -DUSE_NCCL=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace






