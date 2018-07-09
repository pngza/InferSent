#!/bin/bash

set -xu

group_timestamp=$(date -u +\%Y\%m\%d-\%H\%M\%S)
run_idx=0

# for optimizer in "--optimizer=adam"; do
for optimizer in ""; do
    for encoder_type in InferSent ConvNetEncoder; do
        ((run_idx+=1))
        idx=$(printf "%02d" $run_idx)
        rnd=$(pwgen 5 1)

        unbuffer python ./train_nli.py \
            $optimizer \
            --encoder_type=$encoder_type \
            --gpu_id=3 \
            --outputdir=tmp/ \
            --outputmodelname=infersent-${group_timestamp}-${idx}-${rnd}.pkl \
        &> >(tee stderr tmp/infersent-${group_timestamp}-${idx}-${rnd}.log)
    done
done
