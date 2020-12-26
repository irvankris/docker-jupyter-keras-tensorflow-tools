# Build

NOTE: ini adalah fork dari https://github.com/cannin/docker-jupyter-keras-tensorflow-tools

docker ini saya gunakan sebagai development pipeline untuk pengembangan TensorFlow.

setelah clone, masuk ke dalam direktory docker-jupyter-keras-tensorflow-tools.

lalu 

clone model dan tensorflow   
git clone https://github.com/tensorflow/models.git     
git clone https://github.com/tensorflow/tensorflow.git   

akan menghasilkan direktory models dan tensorflow

direktory models akan di-COPY (bukan di-map), sehingga perubahan direktory models di dalam container, tidak bisa diakses langsung atau tidak ter-replikasi pada host.

untuk mengganti ke tensorflow versi 2, silahkan edit Dockerfile dan sesuaikan (atur hashtag) dengan docker tensorflow 2.

saya hanya menggunakan tensorflow CPU

```
docker build -t cannin/jupyter-keras-tensorflow-tools:tf-1.4.0-devel-py3 -f Dockerfile .
docker build -t cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.4.0-devel-py3 -f Dockerfile_ssh .

```

untuk pengembangan tensorflow, saya lebih menyukai ssh ke container ,seolah saya sedang bekerja dalam server tersendiri.
saya menambahkan expose port 8080 dan 5000 untuk expose web server/service, seperti pada https://github.com/AIZOOTech/flask-object-detection   .

# SSH
```
docker rm -f keras; docker run --name keras -p 2222:22 -p 8888:8888 -p 8080:8000 -p 8081:5000 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.15.2-py3 jupyter lab --allow-root --no-browser

```
