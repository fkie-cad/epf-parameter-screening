#!/bin/bash

FUZZER="${FUZZER:-}"

if [[ "$FUZZER" = "epf" ]]; then
    ./scripts/05_run_epf_experiment.bash
elif [[ "$FUZZER" = "aflnet" ]]; then
    ./scripts/06_run_aflnet_experiment.bash
else
    echo "Start the fuzzer evaluation. Synopsis: FUZZER=<epf|aflnet> [AFFIRMATIVE=yes] [RUNS=n] $0"
    exit 1
fi

