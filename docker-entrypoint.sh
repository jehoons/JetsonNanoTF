#!/bin/bash -eu
cmd="$1"
if [ "${cmd}" == "jup" ]; then
    export SHELL=/bin/bash
    jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root 
else
    exec "$@"
fi
