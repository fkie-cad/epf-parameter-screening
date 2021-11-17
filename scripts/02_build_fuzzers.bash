#!/bin/bash

REPO=`git rev-parse --show-toplevel`

CURR=`pwd`

FUZZERS="$REPO/fuzzers"
AFLNET_FUZZER="$FUZZERS/aflnet"
EPF_FUZZER="$FUZZERS/epf"

echo "==> Building fuzzers..."

echo "Building AFLNet..."
cd "$AFLNET_FUZZER" && make clean all
cd "$AFLNET_FUZZER/llvm_mode" && make

echo "Preparing EPF..."
cd "$EPF_FUZZER"
python3 -m venv .venv
source .venv/bin/activate
pip3 install --upgrade pip
pip3 install -r requirements.freezed.txt
deactivate
cd $CURR

