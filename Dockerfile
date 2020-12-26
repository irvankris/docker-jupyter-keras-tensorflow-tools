#FROM tensorflow/tensorflow:2.2.1-py3
FROM tensorflow/tensorflow:1.15.2-py3
#FROM tensorflow/tensorflow:1.4.0-devel-py3

# FROM: https://hub.docker.com/r/rafaelmonteiro/deep-learning-toolbox/~/dockerfile/
# FROM: https://hub.docker.com/r/windj007/jupyter-keras-tools/~/dockerfile/

RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99AcquireRetries

RUN apt-get update

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
RUN apt-get install -y tzdata

RUN apt-get install -y build-essential
#RUN apt-get install -y screen nano htop git wget links less

RUN apt-get install -y \
    screen \
    nano \
    htop \
    wget \
    links \
    less \
    git \
    gpg-agent \
    python3-cairocffi \
    protobuf-compiler \
    python3-pil \
    python3-lxml \
    curl \
    lsb-release \
    vim \
    libsm6 \ 
    libxext6 \
    python3-pip \
    python3-dev \
    pkg-config \
#    libpng12-dev \
    libgtk2.0-dev \
    gfortran \
#    libatlas-base-dev \
#    libatlas-dev \ 
#    libatlas3-base \
    ffmpeg \
    graphviz \
    python3-tk \
    libxslt-dev \
    libhdf5-dev \
    libxml2-dev \
    libfreetype6-dev \
    libboost-program-options-dev \
    zlib1g-dev \
    libboost-python-dev


# Install Python 3
#RUN apt-get install -y python python-pip python-dev
#RUN apt-get install -y python3-pip python3-dev

# Install ML Dependencies
## Install OpenCV dependencies
#RUN apt-get install -y pkg-config libpng12-dev libgtk2.0-dev gfortran libatlas-base-dev libatlas-dev libatlas3-base ffmpeg

## Install ML Dependencies
#RUN apt-get -y install graphviz python3-tk libxslt-dev libhdf5-dev libxml2-dev

## Install miscellaneous dependencies (Needed?)
#RUN apt-get -y install libfreetype6-dev libboost-program-options-dev zlib1g-dev libboost-python-dev

###########

# INSTALL ML MODULES
#WORKDIR /

## Install OpenCV
#RUN apt-get -y install build-essential cmake git pkg-config
#RUN apt-get -y install libjpeg8-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
#RUN apt-get -y install libgtk2.0-dev
#RUN apt-get -y install libatlas-base-dev gfortran

# From: http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/
#RUN wget https://github.com/opencv/opencv/archive/3.2.0.tar.gz -O /opencv.tar.gz
#RUN wget https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz -O /opencv_contrib.tar.gz
#COPY opencv.tar.gz /opencv.tar.gz
#COPY opencv_contrib.tar.gz /opencv_contrib.tar.gz
#RUN tar xfvz /opencv.tar.gz
#RUN tar xfvz /opencv_contrib.tar.gz

#RUN mkdir -p /opencv-3.2.0/build
#WORKDIR /opencv-3.2.0/build
#RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
#	-D CMAKE_INSTALL_PREFIX=/usr/local \
#	-D INSTALL_C_EXAMPLES=OFF \
#	-D INSTALL_PYTHON_EXAMPLES=OFF \
#	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.2.0/modules \
#	-D BUILD_EXAMPLES=OFF .. && make -j4 && make install && ldconfig && rm -rf /opencv-3.2.0 && rm -rf /opencv_contrib-3.2.0


# Install gcloud and gsutil commands
# # https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
apt-get update -y && apt-get install google-cloud-sdk -y
#
#             # Add new user to avoid running as root
#RUN useradd -ms /bin/bash tensorflow
#USER tensorflow
#WORKDIR /home/tensorflow
#
WORKDIR /root
#
#             # Copy this version of of the model garden into the image
#COPY --chown=tensorflow ./models /home/tensorflow/models
COPY ./models /root/models
#COPY ./tensorflow /root/tensorflow

#
#             # Compile protobuf configs
#RUN (cd /home/tensorflow/models/research/ && protoc object_detection/protos/*.proto --python_out=.)
#WORKDIR /home/tensorflow/models/research/

RUN (cd /root/models/research/ && protoc object_detection/protos/*.proto --python_out=.)
WORKDIR /root/models/research/



#
RUN cp object_detection/packages/tf1/setup.py ./
#ENV PATH="/home/tensorflow/.local/bin:${PATH}"
ENV PATH="/root/.local/bin:${PATH}"


ENV TF_CPP_MIN_LOG_LEVEL 3

## Install ML Modules
COPY requirements.txt requirements.txt
#RUN pip install -r requirements.txt
RUN pip3 install --timeout=60 -r requirements.txt

RUN export PYTHONPATH=$PYTHONPATH:/root/models/research:/root/models/research/object_detection:/root/models/research/slim:/root/models/research/slim/datasets:/root/models/research/slim/deployment:/root/models/research/slim/nets:/root/models/researh/slim/preprocessing:/root/models/research/slim/scripts


CMD ["python", "setup.py", "install"]




## Install GPU-specific debugging
# From: http://xcat-docs.readthedocs.io/en/stable/advanced/gpu/nvidia/verify_cuda_install.html

VOLUME ["/notebooks", "/jupyter/certs"]

#ADD test_scripts /test_scripts
ADD jupyter /jupyter
ENV JUPYTER_CONFIG_DIR="/jupyter"

# Install extensions
RUN jupyter contrib nbextension install --user
RUN jupyter serverextension enable --py jupyterlab --sys-prefix

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

#WORKDIR "/notebooks"
WORKDIR "/root/models/research/object_detection"


CMD ["/run_jupyter.sh"]
