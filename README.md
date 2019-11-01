# jetson-tf1

qemu 설치하기 

```
sudo apt-get install -y qemu binfmt-support qemu-user-static
wget http://archive.ubuntu.com/ubuntu/pool/main/b/binfmt-support/binfmt-support_2.1.8-2_amd64.deb
sudo apt install ./binfmt-support_2.1.8-2_amd64.deb
rm binfmt-support_2.1.8-2_amd64.deb
```

```
sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt update
sudo apt -y install podman
```

기본적인 도커파일의 구조는 아래와 같다.

```
FROM nvcr.io/nvidia/l4t-base:r32.2
WORKDIR /
RUN apt update && apt install -y --fix-missing make g++
RUN apt update && apt install -y --fix-missing python3-pip libhdf5-serial-dev hdf5-tools
RUN apt update && apt install -y python3-h5py
RUN pip3 install --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu
RUN pip3 install -U numpy
CMD [ "bash" ]
```

```
podman pull nvcr.io/nvidia/l4t-base:r32.2
podman build -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -t docker.io/jhsong/jetson_tf1:0.1.0 . -f ./Dockerfile
podman push docker.io/zcw607/jetson:0.1.0
```

도커 허브에 푸시하기 위해서는 먼저 로그인해야 한다. 
```
docker login docker.io
```

**참고문서**

도커 컨테이너를 크로스빌드하기: 

https://medium.com/@chengweizhang2012/how-to-run-keras-model-on-jetson-nano-in-nvidia-docker-container-b52d0df07129
