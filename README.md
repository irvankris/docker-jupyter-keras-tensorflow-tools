# Build

NOTE: ini adalah fork dari https://github.com/cannin/docker-jupyter-keras-tensorflow-tools

docker ini saya gunakan sebagai development pipeline untuk pengembangan TensorFlow.

setelah clone, masuk ke dalam direktory docker-jupyter-keras-tensorflow-tools.

lalu 

clone model dan tensorflow
git clone https://github.com/tensorflow/models.git
git clone https://github.com/tensorflow/tensorflow.git




```
docker build -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-py3 -f Dockerfile .
docker build -t cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3 -f Dockerfile_ssh .

sudo nvidia-docker build -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-gpu-py3 -f Dockerfile_gpu .
sudo nvidia-docker build -t cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-gpu-py3 -f Dockerfile_ssh .
```

# Run
```
## Jupyter
docker rm -f keras; docker run --name keras -v $(pwd):/notebooks -p 8888:8888 -p 6006:6006 -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-py3

docker rm -f keras; docker run --name keras -v $(pwd):/notebooks -p 8888:8888 -p 6006:6006 -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-py3 jupyter lab --allow-root --no-browser

## Bash
docker rm -f keras; docker run --name keras -i -v $(pwd):/notebooks -p 8888:8888 -p 6006:6006 -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-py3 bash

## Interactive shell
docker exec -it keras bash
```

# SSH
```
docker rm -f keras; docker run -d --name keras -p 23:22 -p 8888:8888 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -t cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3

docker rm -f keras; docker run --name keras -p 23:22 -p 8888:8888 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3 bash

docker rm -f keras; docker run --name keras -p 23:22 -p 8888:8888 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3 jupyter lab --allow-root --no-browser

# First time access may be slow
sudo nvidia-docker rm -f keras; sudo nvidia-docker run --name keras -p 23:22 -p 8888:8888 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-gpu-py3

# NOTE: No GPU
docker rm -f keras; docker run --name keras -p 3333:22 -p 9999:8888 -p 6666:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3

docker exec -it keras bash
ssh -p 23 root@localhost
```

# AWS Instructions

Instructions for AWS instance setup instructions

## CUDA Installation
```
See https://github.com/cannin/aws-cuda-docker-install
```

# Basic GPU Test
```
cd /usr/local/cuda-8.0/samples/quasirandomGenerator
make clean; make; ./quasirandomGenerator
```
