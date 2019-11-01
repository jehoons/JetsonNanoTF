#!/bin/bash 
IMAGE=docker.io/jhsong/jetsontf:0.1
CONTAINER=jetson
DOCKER_HOME=/root
HOST_SCRATCH_DIR=${HOME}/.scratch
DOCKER_SCRATCH_DIR=${DOCKER_HOME}/.scratch
VOLUMNE_MAPS="-v ${HOST_SCRATCH_DIR}:${DOCKER_SCRATCH_DIR} -v `pwd`/share:${DOCKER_HOME}/share -v /var/run/docker.sock:/var/run/docker.sock" 
# VOLUMNE_MAPS="-v ${HOST_SCRATCH_DIR}:${DOCKER_SCRATCH_DIR} -v /var/run/docker.sock:/var/run/docker.sock" 
ENVVARS="-e HOST_USER=${ME}"
PORT_MAPS=-P 

shell(){
    docker exec -it ${CONTAINER} su root
}

build(){
    docker build . -t ${IMAGE}
}

start(){
    mkdir -p ${HOST_SCRATCH_DIR}
    docker run --runtime nvidia --network host -it --rm \
	    --name ${CONTAINER} ${ENVVARS} ${PORT_MAPS} ${VOLUMNE_MAPS} ${IMAGE} 
}

stop(){
    docker stop ${CONTAINER}
}

rmi(){
    docker rmi ${IMAGE}
}

source $(dirname $0)/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('exec_mode', type=str, 
    help='build|start|stop|shell|update'
    )
EOF

case "${EXEC_MODE}" in
    shell)
        shell 
        ;; 
    build)
        build 
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    rmi)
        rmi
        ;;
    update)
        build 
        if [ $? -eq 0 ] 
        then  
            echo "wait stoping ..."
            stop 
        wait 
            start
        else 
            echo "build failed"
        fi 
        ;; 
    *)
        echo 
esac

