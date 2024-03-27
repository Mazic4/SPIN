#!/bin/bash

version="v2_10"

BASE_DIR="/maas-vepfs/spin-outputs/ecom/mrgt/${version}/"
data_dir_base="./test_scripts/data_"
out_dir_base="./mrgt/test_generated/lang/${version}/init/"
generate_output_dir_base="./mrgt/test_generated/lang/${version}/"

mkdir -p $BASE_DIR $out_dir_base $generate_output_dir_base

for lang in en; do
    data_dir=${data_dir_base}${lang}
    out_dir=${out_dir_base}${lang}

    python spin/reformat_mrgt_test.py --data $data_dir --output_dir $out_dir

    IFS=$'\n' read -r -d '' -a checkpoint_dirs <<< "$(find "$BASE_DIR" -type d -name "checkpoint-*" | grep 'checkpoint-.*$')"

    sft_model_dir="/maas-vepfs/models/ecom/mrgt/mrgt_mixchat/"
    sft_generate_output_dir="./mrgt/test_generated/lang/sft/mix/${lang}"
    python3 spin/batched_generate_vllm_mrgt_inference.py --model "$sft_model_dir" --input_dir "$out_dir" --frac_len 968 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir "$sft_generate_output_dir"
    
    # Loop through the array of directories
    for model_dir in "${checkpoint_dirs[@]}"; do
        # Extract checkpoint number or identifier from directory name
        checkpoint=$(basename "$model_dir" |sed 's/checkpoint-//')
        echo $checkpoint
        if [[ $model_dir =~ iter([0-9]+) ]]; then
            iter_number=${BASH_REMATCH[1]}
        fi
        generate_output_dir=${generate_output_dir_base}iter${iter_number}/checkpoint-$checkpoint/${lang}

        echo $generate_output_dir
        echo $model_dir
        echo
        # Execute your Python script with the dynamically determined directories
        python3 spin/batched_generate_vllm_mrgt_inference.py --model "$model_dir" --input_dir "$out_dir" --frac_len 968 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir "$generate_output_dir"
    done

done