# Set which GPU devices to be visible to the process, --num_processes should be adjusted accordingly
export CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7"

# Set the home directory for Hugging Face transformers library cache.
#export HF_HOME="${your_hf_home}"

# Set the logging level for the `accelerate` library to output informational messages.
ACCELERATE_LOG_LEVEL=info

MAIN_BASE_DIR=$(pwd)/mrgt/generated/v5/
MODEL_BASE_DIR=/maas-vepfs/spin-outputs/ecom/mrgt/v5/
CONFIG_BASE_DIR="configs/mrgt/v5/"

mkdir -p ${MODEL_BASE_DIR}
mkdir -p ${MAIN_BASE_DIR}
mkdir -p ${CONFIG_BASE_DIR}

N_ITERATIONS=1
for iter in 0 1 2 3; do

    # #run generation via batch llm
    if [ "$iter" -eq 0 ]; then
        model_dir="/maas-vepfs/models/ecom/mrgt/v3"
    else
        model_dir="${MODEL_BASE_DIR}/iter$((iter-1))"
    fi

    data_dir="${MAIN_BASE_DIR}/init"
    output_dir="${MAIN_BASE_DIR}/iter$iter"

    python3 spin/batched_generate_vllm_mrgt_v3.py --model $model_dir --input_dir $data_dir --frac_len 10000 --num_data_frac 8 --tp_per_worker 1 --output_dir $output_dir
    python3 spin/batched_generate_vllm_mrgt_v3.py --model $model_dir --input_dir $data_dir --frac_len 500 --num_data_frac 8 --tp_per_worker 1 --split test --output_dir $output_dir

    echo "Iteration $iter: generation done"

    # #convert datatype
    input_dir=$output_dir
    data_output_dir=$output_dir"_post"

    python spin/convert_data.py --num_fracs 8 --input_dir $input_dir --output_dir $data_output_dir

    echo "Iteration $iter: convert data type done"

    # #finetune
    output_dir=${MODEL_BASE_DIR}/iter$iter
    config_path=${CONFIG_BASE_DIR}config_iter$iter.yaml

    bash scripts/write_config_v4.sh $model_dir $data_output_dir": 1.0" $config_path

    accelerate launch --config_file configs/deepspeed_zero3.yaml --num_processes=8 --main_process_port 2950 \
    spin/run_spin.py $config_path --num_train_epochs=3 --output_dir=$output_dir

    echo "Iteration $iter: finetuning done"


done