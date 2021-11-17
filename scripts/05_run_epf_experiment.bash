#!/bin/bash

tmux_session="epf"

RUNS="${RUNS:-3}"

if [[ -z "${ALPHA}" || -z "${BETA}" || -z "${LIMIT}" || -z "${MUT}" || -z "${PRNG_SEED}" ]]; then
    echo "Please specify the ALPHA, BETA, LIMIT, MUT, and PRNG_SEED env vars"
    echo "aborting..."
    exit 1
fi

if [[ -z "${AFFIRMATIVE}" ]]; then
    echo "WARNING: This script runs $RUNS fuzzer instances in parallel..."
    echo "         If this is not what you want, please pass the count of parallel runs using the"
    echo "         RUNS environment variable."
    echo "         Also, you might skip this warning by setting the AFFIRMATIVE environment variable."
    echo
    echo "   e.g.: RUNS=10 AFFIRMATIVE=roger $0"
    echo
    read -p "Are you sure you want to continue (y | n)? " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "aborting..."
        exit 1
    fi
fi

REPO=`git rev-parse --show-toplevel`

FUZZERS="$REPO/fuzzers"
EPF_FUZZER="$FUZZERS/epf"

RESULTS="$REPO/dataset/epf"
TARGET="$REPO/targets/original/lib60870/lib60870-C/examples/cs104_server_no_threads/cs104_server_no_threads"
SEEDS="$REPO/seed_files/pcap/iec104.pcap"

echo "===> Starting EPF screening..."

#create new session
tmux new-session -d -s $tmux_session

current_window="1-4"
id_window="0"

budget=86400

for run in `seq 0 $(($RUNS-1))`; do
	n=$(($run % 3))
	if [ "$n" -eq "0" ]; then
		current_window="$run-$(($run+3))"
		id_window="$(($id_window + 1))"
		tmux new-window -t $tmux_session:$id_window -n "$current_window"
		for _ in {1..2}; do tmux split-window -h -t $tmux_session:$id_window; done
	fi

	result_dir="$RESULTS/epf_${ALPHA}_${BETA}_${LIMIT}_${MUT}_${PRNG_SEED}_${budget}_0.05_${run}"
	mkdir -p $result_dir

	target_port=$(("31000" + "$run"))
	shm_id="${target_port}"
	prng_seed=$(python3 -c "import random; print(random.randint(0, 0xFFFFFFFF), end='')")

	cmd="python3 -m epf 127.0.0.1 $target_port -p tcp --fuzzer iec104 --pcap $SEEDS --seed $PRNG_SEED --restart afl_fork '$TARGET $target_port' --smut $MUT --plimit $LIMIT --alpha $ALPHA --beta $BETA --debug --batch --output $result_dir --budget $budget --shm_id $shm_id --dump_shm"

	tmux send-keys -t $tmux_session:$id_window.$n "cd $EPF_FUZZER" C-m
	tmux send-keys -t $tmux_session:$id_window.$n "source .env/bin/activate" C-m
	tmux send-keys -t $tmux_session:$id_window.$n "$cmd" C-m
done

echo "===> Started jobs in background!! Results will be in '$RESULTS'. You can follow the progress in tmux if you want to. The session is called '$tmux_session'"
