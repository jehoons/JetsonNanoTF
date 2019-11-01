FROM nvcr.io/nvidia/l4t-base:r32.2
WORKDIR /
RUN apt update && apt install -y --fix-missing make g++
RUN apt update && apt install -y --fix-missing python3-pip libhdf5-serial-dev hdf5-tools
RUN apt update && apt install -y python3-h5py

# jupyter 
RUN apt install -y nodejs npm python3-pip
RUN pip3 install jupyter jupyterlab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter lab --generate-config

# tensorflow-gpu
RUN pip3 install --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu
RUN pip3 install -U numpy

CMD [ "jup" ]

# jupyter run with following command:
# jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root
