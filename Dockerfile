FROM nvcr.io/nvidia/l4t-base:r32.2
WORKDIR /
RUN apt update && apt install -y --fix-missing make g++
RUN apt update && apt install -y --fix-missing python3-pip libhdf5-serial-dev hdf5-tools
RUN apt update && apt install -y python3-h5py nodejs npm

# jupyter 
RUN pip3 install jupyter jupyterlab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# tensorflow-gpu
RUN pip3 install --pre --no-cache-dir --extra-index-url \
	https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu
RUN pip3 install -U numpy
RUN pip3 install pandas
RUN pip3 install pyserial
RUN apt install -y git 
RUN apt-get -y install cmake 

# jupyter config 
USER root
WORKDIR /root
RUN rm -f /root/.jupyter/jupyter_notebook_config.py 
RUN jupyter lab --generate-config
# password: j 
RUN echo "c.NotebookApp.password = u'sha1:6a87cd9f982d:a4b58204db29c2c49a99a4a27b42b7b1a4d72d3f'" \
	>> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888
COPY docker-entrypoint.sh /docker-entrypoint.sh 
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["jup"]
