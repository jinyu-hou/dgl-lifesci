#!/bin/bash

. /opt/conda/etc/profile.d/conda.sh

function fail {
    echo FAIL: $@
    exit -1
}

function usage {
    echo "Usage: $0 backend device"
}

if [ $# -ne 2 ]; then
    usage
    fail "Error: must specify backend and device"
fi

export DGLBACKEND=$1
export DGL_DOWNLOAD_DIR=${PWD}
export PYTHONPATH=${PWD}/python:$PYTHONPATH

if [ $2 == "gpu" ]
then
  export CUDA_VISIBLE_DEVICES=0
else
  export CUDA_VISIBLE_DEVICES=-1
fi

conda activate ${DGLBACKEND}-ci

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib
which python
conda list
python -m pytest -v --junitxml=pytest_utils.xml tests/utils || fail "utils"