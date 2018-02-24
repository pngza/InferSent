#!/bin/bash

set -xu

group_timestamp=$(date -u +\%Y\%m\%d-\%H\%M\%S)
run_idx=0

for optimizer in " " "--optimizer=adam"; do
    for encoder_type in BLSTMEncoder ConvNetEncoder; do
        for optimizer_name in rmsprop adam; do
            for weight_decay in 0.001 0.0; do

                ((run_idx+=1))
                idx=$(printf "%02d" $run_idx)

                unbuffer python ./train_nli.py \
                    $optimizer \
                    --encoder_type=$encoder_type \
                    --gpu_id=0 \
                &> >(tee stderr tmp/train-${group_timestamp}-${idx}-$(pwgen 5 1).log)
            done
        done
    done
done
