# Build

NOTE: ini adalah fork dari https://github.com/cannin/docker-jupyter-keras-tensorflow-tools

docker/container ini saya gunakan sebagai development-pipeline/development-rig untuk pemanfaatan TensorFlow.

setelah clone, masuk ke dalam direktory docker-jupyter-keras-tensorflow-tools.

lalu 

clone model dan tensorflow   
git clone https://github.com/tensorflow/models.git     
git clone https://github.com/tensorflow/tensorflow.git   

akan menghasilkan direktory models dan tensorflow

lalu jalankan build.

```

docker build -t cannin/jupyter-keras-tensorflow-tools:tf-1.15.2-py3 -f Dockerfile .
docker build -t cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.15.2-py3 -f Dockerfile_ssh .

```

untuk mengganti ke tensorflow versi 2, sebelum build,  silahkan edit Dockerfile dan sesuaikan (atur hashtag) dengan image docker tensorflow 2.
lalu sesuaikan perintah build-nya dengan versi image docker tensorflow yang dipilih.




direktory models akan di-COPY (bukan di-map), sehingga perubahan direktory models di dalam container, tidak bisa diakses langsung atau tidak ter-replikasi pada host.

saya hanya menggunakan tensorflow CPU

untuk pengembangan tensorflow, saya lebih menyukai ssh ke container ,seolah saya sedang bekerja dalam server tersendiri.

saya menambahkan expose port 8080 dan 5000 untuk expose web server/service, untuk mengimplementasikan hasil inference seperti pada : https://github.com/AIZOOTech/flask-object-detection   .

buat direktory notebooks.

gunakan mapping direktory notebooks, sehingga ketika bekerja di dalam container (melalui SSH) kita manfaatkan direktory notebooks sebagai project-directory, untuk memudahkan akses project-directory saat berada di host-server.

untuk menjalankan container :

# SSH
```
docker rm -f keras; docker run --name keras -p 2222:22 -p 8888:8888 -p 8080:8000 -p 8081:5000 -p 6006:6006 -v $(pwd):/notebooks -w /notebooks -it cannin/jupyter-keras-tensorflow-tools-sshd:tf-1.15.2-py3 jupyter lab --allow-root --no-browser

```
akses ssh di port 2222. <br>
akses web jupyter di port 8888. <br>
akses tensorboard di port 6006. <br>
akses web service pada port 8080 dan 8081.  <br>

login ssh : (sesuai pada Dockerfile_ssh)  <br>
user : root  <br>
pass : root  <br>

saya menggunakan container ini untuk menjalankan :
1. https://raw.githubusercontent.com/wkentaro/labelme/master/examples/instance_segmentation/labelme2coco.py   
2. python create_coco_tf_record.py 
3. python model_main.py 
4. tensorboard --logdir=/notebooks/data/dataset02/detectiontrain
5. python export_inference_graph.py 
6. python models/research/object_detection/export_tflite_ssd_graph.py  
7. tflite_convert
8. python import_pb_to_tensorboard.py
9. python /notebooks/tools/tensorflow_quantization/quantization/quantize_graph.py 
10. script :

import tensorflow as tf  <br>
interpreter = tf.contrib.lite.Interpreter("detect.tflite")  <br>
interpreter.allocate_tensors()  <br>
input_details = interpreter.get_input_details()  <br>
output_details = interpreter.get_output_details()  <br>
print(input_details)  <br>
print(output_details) <br>

11. dan lain-lain :D

Semoga Bermanfaat. Terima Kasih

"mengolah data itu mudah. yang sangat susah adalah mengumpulkan datanya."
