#!/bin/bash 
IMAGE=jhsong/imdbenv:latest
ME=$(basename ${HOME})
CONTAINER=imdb_env-${ME}
DOCKER_HOME=/root
HOST_SCRATCH_DIR=${HOME}/.scratch
DOCKER_SCRATCH_DIR=${DOCKER_HOME}/.scratch
VOLUMNE_MAPS="-v ${HOST_SCRATCH_DIR}:${DOCKER_SCRATCH_DIR} -v `pwd`/share:${DOCKER_HOME}/share -v /var/run/docker.sock:/var/run/docker.sock" 
ENVVARS="-e HOST_USER=${ME}"
PORT_MAPS=-P 

shell(){
    docker exec -it ${CONTAINER} su root
}

jup(){
    if [ -e "host.txt" ]
    then 
        hostipaddr=$(cat host.txt)
    else 
        hostipaddr="localhost"
    fi 
    jupaddr=$(cat share/logs/jupyterlab.log | grep -o http://.*:8888/?token=[a-z0-9]* | head -1 | sed "s/0.0.0.0/${hostipaddr}/g")
    jupport=$(docker ps | grep --color ${CONTAINER} | grep -o --color "[0-9]\+->8888\+" | sed "s/->8888//g") 
    addrport="$hostipaddr:$jupport"
    echo $jupaddr | sed "s/http.*8888\//http:\/\/${addrport}\/lab/"

}

build(){
    docker build . --build-arg user=`whoami` --build-arg uid=`id -u` -t ${IMAGE}
}

start(){
    mkdir -p ${HOST_SCRATCH_DIR}
    docker run --rm -d --name ${CONTAINER} ${ENVVARS} ${PORT_MAPS} ${VOLUMNE_MAPS} ${IMAGE} 
    # docker run --rm --name ${CONTAINER} ${PORT_MAPS} ${VOLUMNE_MAPS} -u 1005:1005 ${IMAGE} 
    if [ $? -eq 0 ]
    then 
        sleep 5 
        jup
    fi 
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

parser.add_argument('-f', '--foreground', 
    action='store_true',
    help='run with foreground mode? [default %(default)s]', 
    default=False
    )
EOF

case "${EXEC_MODE}" in

    shell)
        shell 
        ;; 
    jup) 
        jup 
        ;; 
    build)
        build 
        ;;
    start)
        start $FOREGROUND
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
            start $FOREGROUND
        else 
            echo "build failed"
        fi 
        ;; 
    *)
        echo 
esac

