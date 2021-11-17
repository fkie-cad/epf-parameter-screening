#!/bin/bash

REPO=`git rev-parse --show-toplevel`

CURR=`pwd`

FUZZERS="$REPO/fuzzers"
AFLNET_FUZZER="$FUZZERS/aflnet"


TARGETS="$REPO/targets"
TARGET_SYSTEM="$TARGETS/original/lib60870/lib60870-C/make/target_system.mk"
TARGET="$TARGETS/original/lib60870/lib60870-C/examples/cs104_server_no_threads"

echo "==> Building and instrumenting lib60870-C v. 2.2. ..."

echo CC="$AFLNET_FUZZER/afl-clang" >> $TARGET_SYSTEM
cd "$TARGET" && make clean && make
