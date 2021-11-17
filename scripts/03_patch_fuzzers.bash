#!/bin/bash

REPO=`git rev-parse --show-toplevel`

FUZZERS="$REPO/fuzzers"
EPF_FUZZER="$FUZZERS/epf"

PATCHES="$REPO/patches"
EPF_PATCH="$PATCHES/01_epf_fix_broken_iec104_sequence_number_in_scapy_field_model.patch"

echo "==> Applying patches for EPF"

echo "$EPF_PATCH..."
cd `find $EPF_FUZZER/.venv/lib -type d -name "python3.*" | head -n 1` && patch -p1 < "$EPF_PATCH"

